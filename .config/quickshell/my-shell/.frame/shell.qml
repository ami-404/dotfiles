import QtQuick
import Quickshell

// Define a common configuration for the frame borders
pragma ComponentBehavior: Bound

ShellRoot {
    // Replace this with your screen configuration if you use multi-monitor
    id: root

    // Change these values to adjust your border style
    property int frameThickness: 3   // How wide the border is
    property int frameRounding: 25    // Corner curvature
    property color frameColor: "#89b4fa" // Frame color (e.g., Pastel Blue)

    // --- TOP BORDER ---
    PanelWindow {
        height: root.frameThickness
        anchors { top: true; left: true; right: true }
        
        Rectangle {
            anchors.fill: parent
            color: root.frameColor
            // Visual trick: round only the inner corners if desired, or leave flat
        }
    }

    // --- BOTTOM BORDER ---
    PanelWindow {
        height: root.frameThickness
        anchors { bottom: true; left: true; right: true }
        
        Rectangle {
            anchors.fill: parent
            color: root.frameColor
        }
    }

    // --- LEFT BORDER ---
    PanelWindow {
        width: root.frameThickness
        anchors { left: true; top: true; bottom: true }
        
        Rectangle {
            anchors.fill: parent
            color: root.frameColor
            radius: -20
        }
    }

    // --- RIGHT BORDER ---
    PanelWindow {
        width: root.frameThickness
        anchors { right: true; top: true; bottom: true }
        
        Rectangle {
            anchors.fill: parent
            color: root.frameColor
        }
    }
}
