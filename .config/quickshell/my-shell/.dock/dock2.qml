import QtQuick
import QtQuick.Shapes
import Quickshell

PanelWindow {
    id: root
    
    // Attach the bar to the top of the monitor
    anchors {
        top: true
        left: true
        right: true
    }
    
    // Explicitly define the thickness of your status bar
    implicitHeight: 60
    
    // Make the underlying window container transparent 
    // so the custom shape dictates the actual bar geometry
    color: "transparent"

    Shape {
        id: barBackground
        anchors.fill: parent
        
        // Settings for smoother vector rendering
        layer.enabled: true
        layer.samples: 4

        ShapePath {
            // Match your system or desktop theme color here
            fillColor: "#1e1e2e" 
            strokeColor: "transparent"

            // 1. Start at the top-left corner of the monitor
            startX: 0
            startY: 0

            // 2. Draw a straight line to the beginning of the center curve cutout
            // Adjust the subtraction value to make the cutout wider or narrower
            PathLine { x: (root.width / 2) - 150; y: 0 }

            // 3. Curve smoothly INWARD (downward into the bar)
            // controlX/Y determines the pulling point of the curve apex
            PathQuad {
                x: (root.width / 2) - 120
                y: 30
                controlX: (root.width / 2) - 150
                controlY: 30
            }

            // 4. Travel straight across the flat bottom of the cutout
            PathLine { x: (root.width / 2) + 120; y: 30 }

            // 5. Curve back smoothly OUTWARD to resume the top edge
            PathQuad {
                x: (root.width / 2) + 150
                y: 0
                controlX: (root.width / 2) + 150
                controlY: 30
            }

            // 6. Draw straight line to the top-right corner of the monitor
            PathLine { x: root.width; y: 0 }

            // 7. Drop straight down to the bottom-right corner of the bar
            PathLine { x: root.width; y: root.implicitHeight }

            // 8. Line straight across the bottom edge back to the left side
            PathLine { x: 0; y: root.implicitHeight }

            // 9. Close the loop back up to the start point (0,0)
            PathLine { x: 0; y: 0 }
        }
    }

    // Wrap your actual modules (workspaces, clock) inside a normal row layout
    Row {
        anchors.fill: parent
        // Ensure child content stays inside the visual boundaries if necessary
    }
}
