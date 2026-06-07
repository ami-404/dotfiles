import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland // <-- Added native Hyprland integration
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
// import qs.CustomTheme

PanelWindow {
    id: root
    
    // --- 1. OVERLAY & WAYLAND FIXES ---
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: WlrLayershell.Ignore 
    
    implicitWidth: panelBg.implicitWidth + 15
    implicitHeight: panelBg.implicitHeight + 50
    color: "transparent"

    anchors {
        right: true
        top: true
    }

    margins {
				top: 8
    }


    // --- CLICK OUTSIDE TO CLOSE (Native Hyprland) ---
    HyprlandFocusGrab {
        windows: [root]
        active: root.isOpen
        onCleared: {
            if (root.isOpen) {
                root.isOpen = false
            }
        }
    }

    // --- HANDLE ESCAPE SHORTCUT ---
    Shortcut {
        sequence: "Escape"
        onActivated: {
            if (root.isOpen) {
                root.isOpen = false
            }
        }
    }

    // --- 2. ANIMATION LOGIC (FIXED) ---
    property bool isOpen: false
    
    // Keep the window mapped to the screen while the animation is playing
    // visible: isOpen || slideAnim.running
    
    margins {
        right: root.currentMargin
				top: root.currentMargin
    }

    // Window visibility is tied to the internal element's animation
    visible: isOpen || slideAnim.running

    // Ternary operator: If open, set to 20. If closed, set to -150.
    property real currentMargin: isOpen ? 0 : -170 

    // This automatically animates currentMargin whenever it changes!
    Behavior on currentMargin {
        NumberAnimation {
            id: slideAnim
            duration: 350
            easing.type: Easing.OutQuint 
        }
    }

    IpcHandler {
        target: "powermenu"
        function toggle(): void { root.isOpen = !root.isOpen }
        function open(): void { root.isOpen = true }   // <-- Added for Waybar safety
        function close(): void { root.isOpen = false } // <-- Added for Waybar safety
    }

    Process {
        id: powerProcess
        running: false
    }


    // ==========================================
    // MAIN PANEL BACKGROUND (The Pill Shape)
    // ==========================================
    Item {
        id: panelBg
        implicitWidth: 30 
        implicitHeight: buttonLayout.implicitHeight + 20 
        anchors.centerIn: parent

        // Horizontal centering inside the root window bounds
        // anchors.horizontalCenter: parent.horizontalCenter

        // --- TOP TO BOTTOM SLIDE ANIMATION ---
        // When open, y is 0 (snapped to top margins). 
        // When closed, y shifts up by its own negative height minus padding to cleanly disappear off-screen.
        // property real y: root.isOpen ? 20 : -(panelBg.implicitHeight + 40)
        //
        // Behavior on y {
        //     NumberAnimation {
        //         id: slideAnim
        //         duration: 450
        //         easing.type: Easing.OutQuint 
        //     }
        // }

        RectangularShadow {
            id: shadow
            anchors.fill: mainBgRect
            radius: mainBgRect.radius
            blur: 15
            // color: "black"
            color: Qt.rgba(0, 0, 0, 0.4)
            // color: Qt.rgba(Theme.shadow.r, Theme.shadow.g, Theme.shadow.b, 0.4)
        }

        Rectangle {
            id: mainBgRect
            anchors.fill: parent
            color: "#181824"
            border.color: "#cba6f7"
            border.width: 2
            radius: 20
            opacity: 0.9 // Only the background is transparent
        }

        // ==========================================
        // BUTTON LAYOUT
        // ==========================================
        ColumnLayout {
            id: buttonLayout
            anchors.centerIn: parent
            spacing: 8 

            component PowerButton: Rectangle {
                id: btn
                property string iconTxt: ""
                property string cmd: ""
                
                // Add a custom signal to the component
                signal clicked()

                implicitWidth: 20
                implicitHeight: 20
                radius: 15 
                
                color: mouseArea.containsMouse ? "#3f5390" : "transparent"
                border.color: "#3f5390"
                border.width: 0.5

                Text {
                    anchors.centerIn: parent
                    text: btn.iconTxt
                    font.family: "monospace" 
                    font.pixelSize: 10
                    // color: "#cdd6f4"
                    color: mouseArea.containsMouse ? "#fff" : "#cdd6f4"
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        // 1. Emit our custom clicked signal
                        btn.clicked()
                        // 2. Trigger the slide-out animation!
                        root.isOpen = false 
                    }
                }
            }

            PowerButton { 
                iconTxt: ""; 
                onClicked: { Quickshell.execDetached(["loginctl", "lock-session"]) } 
                // onClicked: { Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-power -l"]) } 
            }
            PowerButton { 
                iconTxt: ""; 
                onClicked: { Quickshell.execDetached(["systemctl", "suspend"]) } 
            }
            PowerButton { 
                iconTxt: ""; 
                onClicked: { Quickshell.execDetached(["hyprctl", "dispatch", "exit"]) } 
            }
            PowerButton { 
                iconTxt: ""; 
                onClicked: { Quickshell.execDetached(["systemctl", "reboot"]) } 
            }
            PowerButton { 
                iconTxt: ""; 
                onClicked: { Quickshell.execDetached(["systemctl", "poweroff"]) } 
            }
        }
    }
}
