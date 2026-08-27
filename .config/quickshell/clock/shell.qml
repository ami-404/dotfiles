import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

ShellRoot {
    PanelWindow {
        id: wallpaperClock

        // Target the primary screen (Monitor 0). 
        // If you want it on all screens, wrap this in a Variants {} block like your example.
        screen: Quickshell.screens[0]

        exclusionMode: ExclusionMode.Ignore

        // --- Window Configuration ---
        // Eww: :anchor "top center"
        anchors {
            top: true
            // In Wayland Layer Shell, anchoring only to the top naturally centers the window horizontally.
        }

        // Eww: :y "13%"
        margins {
            // QML doesn't use direct percentage margins, so we bind it to 13% of the screen height.
            top: screen.height * 0.13
        }

        implicitWidth: content.width
        implicitHeight: content.height

        color: "transparent"

        // Eww: :focusable false & :exclusive false
        // The empty region mask ensures all clicks pass through to the desktop.
        mask: Region {}

        // Eww: :stacking "bottom"
        // This keeps the widget glued to the wallpaper, behind your open windows.
        WlrLayershell.layer: WlrLayer.Background
			  // WlrLayershell.layer: WlrLayer.Bottom

        // --- Data State ---
        property string dayText: ""
        property string monthText: ""
        property string timeText: ""

        // Eww: defpoll intervals mapped to a QML Timer
        function updateTime() {
            let d = new Date()
            
            // '%^A' -> Uppercase full weekday
            wallpaperClock.dayText = Qt.formatDate(d, "dddd").toUpperCase()
            
            // '%^b %d,%Y' -> Uppercase short month, day, 4-digit year
            wallpaperClock.monthText = Qt.formatDate(d, "MMM dd,yyyy").toUpperCase()
            
            // '+- %I:%M %p -' -> 12-hour time with AM/PM
            wallpaperClock.timeText = "- " + Qt.formatTime(d, "hh:mm AP") + " -"
        }

        Timer {
            interval: 1000 // 1 second updates
            running: true
            repeat: true
            onTriggered: wallpaperClock.updateTime()
        }

        // Run the function immediately on load so it doesn't wait 1s to appear
        Component.onCompleted: wallpaperClock.updateTime()

        // --- Visual Layout (Eww box & SCSS) ---
        ColumnLayout {
            id: content
            spacing: 0

            Text {
                text: wallpaperClock.dayText
                color: "white"
                font.family: "Anurati" // Ensure this is installed on your system
                font.pixelSize: 75
                font.letterSpacing: 20
                Layout.alignment: Qt.AlignHCenter

                // Lightweight QML alternative to CSS text-shadow
                style: Text.Raised
                styleColor: "black"
            }

            Text {
                text: wallpaperClock.monthText
                color: "white"
                font.family: "Anurati"
                font.pixelSize: 30
                // font.letterSpacing: 5
                Layout.alignment: Qt.AlignHCenter

                style: Text.Raised
                styleColor: "black"
            }

            Text {
                text: wallpaperClock.timeText
                color: "white"
                font.family: "Anurati"
                font.pixelSize: 20
                Layout.topMargin: 5 // Eww: margin-top: 5px
                Layout.alignment: Qt.AlignHCenter

                style: Text.Raised
                styleColor: "black"
            }
        }
    }
}
