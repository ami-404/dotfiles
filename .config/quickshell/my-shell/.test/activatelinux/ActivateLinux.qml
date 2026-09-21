import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

ShellRoot {
	Variants {
		// Create the panel once on each monitor.
		model: Quickshell.screens

		PanelWindow {
			id: w

			property var modelData

			screen: modelData

			anchors {
				right: true
				bottom: true
			}

			margins {
				right: 50
				bottom: 50
			}

			implicitWidth: content.width
			implicitHeight: content.height

      property bool isOpen: false

      visible: isOpen

			color: "transparent"

			// Give the window an empty click mask so all clicks pass through it.
			mask: Region {}

      IpcHandler {
        target: "activate"
        function toggle(): void { w.isOpen = !w.isOpen }
        function open(): void { w.isOpen = true }   // <-- Added for Waybar safety
        function close(): void { w.isOpen = false } // <-- Added for Waybar safety
      }
			// Use the wlroots specific layer property to ensure it displays over
			// fullscreen windows.
			WlrLayershell.layer: WlrLayer.Overlay

			ColumnLayout {
				id: content

        visible: w.visible

				Text {
					text: "Activate Linux"
					color: "#50ffffff"
					font.pointSize: 22
				}

				Text {
					text: "Go to Settings to activate Linux"
					color: "#50ffffff"
					font.pointSize: 14
				}
			}
		}
	}
}
