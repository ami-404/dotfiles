import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell
import Quickshell.Wayland

ShellRoot {
    id: root

    // Global styling variables matching your style.css
    readonly property string fontFamily: "CaskaydiaMono Nerd Font"
    readonly property string textColor: "#cdd6f4"
    readonly property string bgModuleColor: "#181824" // rgb(24, 24, 36)
    readonly property int fontSize: 12

    // Reusable template for a standard text module
    component BarText : Text {
        color: root.textColor
        font.family: root.fontFamily
        font.pixelSize: root.fontSize
        renderType: Text.NativeRendering
        verticalAlignment: Text.AlignVCenter
    }

    PanelWindow {
        id: bar
        anchors {
            top: true
            left: true
            right: true
        }
        implicitHeight: 26
        color: "transparent"

        // Master Layout Wrapper
        Item {
            anchors.fill: parent

            // ==========================================
            // LEFT MODULES CONTAINER
            // ==========================================
            Rectangle {
                id: leftModules
                color: root.bgModuleColor
                radius: 7
                height: parent.height - 2
                anchors {
                    left: parent.left
                    leftMargin: 8
                    verticalCenter: parent.verticalCenter
                }
                width: leftLayout.implicitWidth + 16

                RowLayout {
                    id: leftLayout
                    anchors.centerIn: parent
                    spacing: 8

                    // custom/rofi
                    BarText {
                        text: "󰣇 "
                        color: "#1793d1"
                        font.pixelSize: 15
                        font.bold: true
                        
                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked: (mouse) => {
                                if (mouse.button === Qt.LeftButton) rofiLeftClick.start();
                                if (mouse.button === Qt.RightButton) rofiRightClick.start();
                            }
                        }
                        
                        Process { id: rofiLeftClick; command: ["/bin/sh", "-c", "/home/ameen/.config/rofi/launchers/type-6/launcher.sh"] }
                        Process { id: rofiRightClick; command: ["/bin/sh", "-c", "qs -c my-shell ipc call overview toggle"] }
                    }

                    // custom/line separator
                    BarText { text: "|" }

                    // hyprland/workspaces (Visual Scaffold)
                    RowLayout {
                        spacing: 6
                        BarText { text: "󱓻"; font.bold: true } 
                        BarText { text: ""; opacity: 0.5 }
                        BarText { text: ""; opacity: 0.5 }
                        BarText { text: ""; opacity: 0.5 }
                        BarText { text: ""; opacity: 0.5 }
                    }

                    // custom/line separator
                    BarText { text: "|" }

                    // hyprland/language
                    BarText { 
                        text: "US" 
                        MouseArea {
                            anchors.fill: parent
                            onClicked: langClick.start()
                        }
                        Process { id: langClick; command: ["/bin/sh", "-c", "hyprctl dispatch keyboard-layout next"] }
                    }
                }
            }

            // ==========================================
            // CENTER MODULES CONTAINER
            // ==========================================
            Rectangle {
                id: centerModules
                color: root.bgModuleColor
                radius: 7
                height: parent.height - 2
                anchors.centerIn: parent
                width: centerLayout.implicitWidth + 16

                RowLayout {
                    id: centerLayout
                    anchors.centerIn: parent
                    spacing: 10

                    // clock
                    BarText {
                        id: clockText
                        property bool alternateFormat: false
                        text: alternateFormat ? Qt.formatDateTime(new Date(), "dd MMMM dff yyyy") : Qt.formatDateTime(new Date(), "dddd HH:mm")

                        Timer {
                            interval: 1000
                            running: true
                            repeat: true
                            onTriggered: clockText.text = clockText.alternateFormat ? Qt.formatDateTime(new Date(), "dd MMMM dff yyyy") : Qt.formatDateTime(new Date(), "dddd HH:mm")
                        }

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.RightButton
                            onClicked: clockText.alternateFormat = !clockText.alternateFormat
                        }
                    }

                    // idle_inhibitor
                    BarText {
                        id: idleInhibitor
                        property bool activated: false
                        text: activated ? "" : ""
                        MouseArea {
                            anchors.fill: parent
                            onClicked: idleInhibitor.activated = !idleInhibitor.activated
                        }
                    }
                }
            }

            // ==========================================
            // RIGHT MODULES CONTAINER
            // ==========================================
            Rectangle {
                id: rightModules
                color: root.bgModuleColor
                radius: 7
                height: parent.height - 2
                anchors {
                    right: parent.right
                    rightMargin: 8
                    verticalCenter: parent.verticalCenter
                }
                width: rightLayout.implicitWidth + 20

                RowLayout {
                    id: rightLayout
                    anchors.centerIn: parent
                    spacing: 12

                    // memory
                    BarText { text: "  " }

                    // cpu
                    BarText { 
                        text: "󰍛" 
                        MouseArea {
                            anchors.fill: parent
                            onClicked: cpuClick.start()
                        }
                        Process { id: cpuClick; command: ["/bin/sh", "-c", "$TERMINAL -e btop"] }
                    }

                    // bluetooth
                    BarText { 
                        text: " " 
                        MouseArea {
                            anchors.fill: parent
                            onClicked: btClick.start()
                        }
                        Process { id: btClick; command: ["/bin/sh", "-c", "blueberry"] }
                    }

                    // custom/notifi
                    BarText { 
                        text: " " 
                        MouseArea {
                            anchors.fill: parent
                            onClicked: notifiClick.start()
                        }
                        Process { id: notifiClick; command: ["/bin/sh", "-c", "qs -c my-shell ipc call notifications toggle"] }
                    }

                    // tray placeholder
                    BarText { text: ""; font.pixelSize: 12 }

                    // backlight
                    BarText { text: " " }

                    // pulseaudio
                    BarText { 
                        text: " " 
                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked: (mouse) => {
                                if (mouse.button === Qt.LeftButton) volLeftClick.start();
                                if (mouse.button === Qt.RightButton) volRightClick.start();
                            }
                        }
                        Process { id: volLeftClick; command: ["/bin/sh", "-c", "pactl set-sink-mute @DEFAULT_SINK@ toggle"] }
                        Process { id: volRightClick; command: ["/bin/sh", "-c", "pavucontrol"] }
                    }

                    // custom/power
                    BarText { 
                        text: " 󰐥 " 
                        font.bold: true
                        MouseArea {
                            anchors.fill: parent
                            onClicked: powerClick.start()
                        }
                        Process { id: powerClick; command: ["/bin/sh", "-c", "qs -c my-shell ipc call powermenu toggle"] }
                    }
                }
            }
        }
    }
}
