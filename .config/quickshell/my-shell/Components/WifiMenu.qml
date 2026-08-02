import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Networking
import "../Singletons"

// A separate window layer that sits on top of your desktop
Scope {
    id: root

    property var theme: DefaultTheme {}
    readonly property var network: QsServices.Network


    // Only instantiate the heavy UI when the user clicks the button
    LazyLoader {
        // active: true
        active: MenuState.wifiMenuOpen
        
        PanelWindow {
            anchors.top: true
            anchors.right: true // Adjust based on your bar's position
            margins.top: 10     // Push it down below your status bar
            margins.right: 10
            color: "Transparent"
            
            width: 300
            height: 400
            exclusionMode: ExclusionMode.None // Ensures it floats OVER windows

            Rectangle {
                id: networkPanel
                anchors.fill: parent
                color: "#1e1e2e" // Your theme background
                border.color: "#313244"
                radius: 8

                ColumnLayout {
                    id: centerColumn
                    anchors.fill: parent
                    // spacing: 2

                    // Header
                    Row {
                        Layout.fillWidth: true
                        anchors.top: parent.top
                        spacing: 10

                        Rectangle {
                            width: 36
                            height: 36

                            Text {
                                text: {
                                if (SystemInfo.networkType === "ethernet") return "󰈀"
                                if (SystemInfo.networkType === "wifi") return "󰖩"
                                return "󰖪"
                                }
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                text: "WiFi Networks"
                                font.family: "Inter"
                                font.pixelSize: 15
                                font.weight: Font.Bold
                                color: root.theme.accentPrimary
                            }

                            Text {
                                // text: network.active ? network.active.ssid : "Not connected"
                                text: SystemInfo.networkInfo
                                font.family: "Inter"
                                font.pixelSize: 11
                                color: root.theme.accentPrimary
                            }
                        }

                        // rescan button
                        Rectangle {
                            width: 24; height: 24; radius: 12
                            Text {
                              text: "󰑐"
                              font.pixelSize: 15
                              anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                // onClicked: ToggleService.toggleWifi()
                                onClicked: ToggleService.scanWifi()
                            }
                        }

                        // toggle button
                        Rectangle {
                            width: 44; height: 24; radius: 12
                            Rectangle {
                                width: 18; height: 18; radius: 9
                                anchors.verticalCenter: parent.verticalCenter
                                x: Networking.wifiEnabled ? parent.width - width - 3 : 3
                                color: root.theme.accentPrimary
                            }

                            MouseArea {
                                anchors.fill: parent
                                // onClicked: ToggleService.toggleWifi()
                                onClicked: Networking.wifiEnabled = !Networking.wifiEnabled
                            }
                        }
                    }

                    ColumnLayout {
                        Repeater {
                            model: Networking.devices
                            delegate: ColumnLayout {
                                Text { text: "Device Name: " + modelData.name; color: root.theme.accentPrimary }

                                // If it's a Wi-Fi device, you can list available networks
                                Repeater {
                                    model: modelData.networks
                                    delegate: Text {
                                        text: modelData.name + (modelData.connected ? " (Connected)" : "")
                                        color: root.theme.accentPrimary
                                        
                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                if (!modelData.connected) {
                                                    modelData.connect()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    
                }

                


                Text {
                    // anchors.centerIn: parent
                    text: "Wi-Fi Networks Go Here"
                    color: "white"
                    visible: false
                }
            }
        }
    }
}
