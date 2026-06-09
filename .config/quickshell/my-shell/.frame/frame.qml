import QtQuick
import Quickshell
import Quickshell.Widgets

ShellRoot {
    id: root

    // --- CONFIGURATION ---
    property int frameThickness: 3      // The thickness of the border frame
    property int cornerRadius: 24        // The roundness of your screen corners
    property color frameColor: "#89b4fa"   // Pastel Blue (Catppuccin Mocha)

    PanelWindow {
        id: fullScreenOverlay
        
        // CRITICAL FIX 1: Set the window's own background color to transparent.
        // Without this, the window stays opaque and blocks your workspace!
        color: "transparent"

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        // CRITICAL FIX 2: Explicitly map the mask region to our visual frame item.
        // By using 'Intersection.Xor', we invert the logic: 
        // Only the visible blue borders are clickable, while the center center passes mouse events.
        mask: Region {
            item: visualFrame
            intersection: Intersection.Xor
        }

        // The outer bounding layout container
        Item {
            anchors.fill: parent

            // The main visual element. A rectangle with a transparent 
            // center cutout that holds your corner radius properties.
            ClippingWrapperRectangle {
                id: visualFrame
                anchors.fill: parent
                
                // Set the border characteristics to form your frame
                border.width: root.frameThickness
                border.color: root.frameColor
                radius: root.cornerRadius

                // Set the inner canvas color to clear, opening up the view inside the window layer
                color: "transparent"
            }
        }
    }
}
