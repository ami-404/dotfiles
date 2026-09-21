import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris

import "../Singletons"


PanelWindow {
  id: root
  required property var modelData
  visible: root.barVisible

  anchors {
    top: true
    left: true
    right: true
  }

  IdleInhibitor {
    window: root
    enabled: ToggleService.inhibitIdle
  }

  implicitHeight: 25

  color: 'transparent'
  property var theme: DefaultTheme {}
  property string font: "Hack Nerd Font"
  property bool barVisible: true

  // MPRIS active player
  property var activePlayer: {
    const players = Mpris.players.values;
    if (!players || players.length === 0) return null;
    for (const p of players) {
      if (p.playbackState === MprisPlaybackState.Playing) return p;
    }
    return players[0];
  }

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink]
  }

  // brightness
  property real brightnessValue: 0
  property real brightnessMax: 1

  FileView {
    id: brightnessFile
    path: ""
    watchChanges: true
    onFileChanged: brightnessReadProc.running = true
  }

  Process {
  id: brightnessReadProc
  command: ["brightnessctl", "get"]
  running: false
  stdout: StdioCollector {
    onStreamFinished: {
      const val = parseInt(text.trim());
      if (!isNaN(val) && root.brightnessMax > 0)
        root.brightnessValue = val / root.brightnessMax;
      }
    }
  }

  Process {
  id: backlightDiscovery
  command: ["sh", "-c", "p=$(ls -d /sys/class/backlight/*/brightness 2>/dev/null | head -1); [ -n \"$p\" ] && echo \"$p\" && cat \"${p%brightness}max_brightness\""]
  running: true
  stdout: StdioCollector {
    onStreamFinished: {
      const lines = text.trim().split("\n");
      if (lines.length >= 2) {
        const max = parseInt(lines[1]);
        if (!isNaN(max) && max > 0) root.brightnessMax = max;
        brightnessFile.path = lines[0];
        brightnessReadProc.running = true;
        }
      }
    }
  }

  Process {
  id: brightnessSetProc
  running: false
  }

  RowLayout {
    anchors.fill: parent
    anchors.leftMargin: 8
    anchors.rightMargin: 8

    // left section
    Item {
      Layout.fillWidth: true
      Layout.fillHeight: true

      Row{
        id: leftSection
        spacing: 5
        Layout.alignment: Qt.AlignLeft

        // launcher
        Rectangle {
            height: 24
            width: 24
            radius: 12
            color: root.theme.bgSurface

            Text {
                anchors.centerIn: parent
                text: "󰣇"
                color: root.theme.accentPrimary
                font.pixelSize: 12
                font.family: root.font

                MouseArea {
                anchors.fill: parent
                onClicked: launcher.isOpen = !launcher.isOpen
                }
          }

        }

        // clock
        Rectangle {
          height: 24
          width: timeDate.width + 16
          radius: 12
          color: root.theme.bgSurface

          Row {
            id: timeDate
            anchors.centerIn: parent
            spacing: 8

            Row {
              Text {
                anchors.verticalCenter: parent.verticalCenter
                text: Time.hoursString
                color: root.theme.textPrimary
                font.pixelSize: 11
                font.family: root.font
                font.weight: Font.Bold
              }

              Text {
                anchors.verticalCenter: parent.verticalCenter
                text: ":"
                color: root.theme.textPrimary
                font.pixelSize: 11
                font.family: root.font
                font.weight: Font.Normal
                opacity: Time.showColon ? 1.0 : 0.2
              }
                  
              Text {
                anchors.verticalCenter: parent.verticalCenter
                text: Time.minutesString
                color: root.theme.textPrimary
                font.pixelSize: 11
                font.family: root.font
                font.weight: Font.Bold
              }
            }

            Text {
              anchors.verticalCenter: parent.verticalCenter
              text: Time.dateString
              color: root.theme.textSecondary
              font.pixelSize: 11
              font.family: root.font
            }
          }
        }

        // music , cava
        Rectangle {
          id: nowPlaying

          readonly property bool playing:
            root.activePlayer !== null &&
            root.activePlayer.playbackState === MprisPlaybackState.Playing

          visible: playing

          height: 24
          width: nowPlayingContent.width + 16
          radius: 12
          color: root.theme.bgSurface

          Behavior on width {
            NumberAnimation {
              duration: 180
              easing.type: Easing.OutCubic
            }
          }

          Accessible.role: Accessible.Button
          Accessible.name: {
            if (!root.activePlayer)
              return "No media";

            const artist = root.activePlayer.trackArtist || "";
            const title = root.activePlayer.trackTitle || "";

            return "Now playing: " +
              (artist ? artist + " - " : "") +
              title;
          }

          Row {
            id: nowPlayingContent

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 8

            spacing: 7

            // Play / pause
            Text {
              anchors.verticalCenter: parent.verticalCenter

              text: root.activePlayer && root.activePlayer.playbackState === MprisPlaybackState.Playing ? "󰏤" : "󰐊"

              color: root.theme.accentPrimary
              font.pixelSize: 14
              font.family: root.font
            }

            // Song name
            Text {
              anchors.verticalCenter: parent.verticalCenter

              text: {
                if (!root.activePlayer) return "";

                const artist = root.activePlayer.trackArtist || "";
                const title = root.activePlayer.trackTitle || "";

                return artist ? artist + " - " + title : title;
              }

              color: root.theme.textPrimary
              font.pixelSize: 11
              font.family: root.font

              elide: Text.ElideRight
              width: Math.min(implicitWidth, 170)
            }

            // Cava
            Item {
              id: cavaContainer

              width: 70
              height: 18

              CavaVisualizer {
                anchors.fill: parent
                active: nowPlaying.playing
              }
            }
          }

          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                if (root.activePlayer) root.activePlayer.togglePlaying()
            }
          }
        }
      }
    }

    // middle part
    Rectangle {
      id: workspaceBG
      Layout.alignment: Qt.AlignCenter
      color: root.theme.bgSurface
      width: workspaces.width + 16
      height: 24
      radius: 12

      Row {
        id: workspaces
        anchors.centerIn: parent
        anchors.leftMargin: 0
        spacing: 10

        Repeater {
          model: 5 // Number of workspaces

          Rectangle {
            width: (Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.id === (index + 1)) ? 30 : 10
            height: 10
            radius: 8
            color: (Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.id === (index + 1)) ? root.theme.accentPrimary : "#45475a"

            // width change animation
            Behavior on width {
              NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
              }
            }

            // Smooth animation for color changes
            Behavior on color {
              ColorAnimation {
                duration: 200
                easing.type: Easing.OutCubic
              }
            }

            MouseArea {
              anchors.fill: parent
              onClicked: {
                Hyprland.dispatch(`hl.dsp.focus({ workspace = ${index + 1} })`)
              }
            }
          }
        }
      }

    }

    // right part
    Item {
      Layout.fillWidth: true
      Layout.fillHeight: true
      Row{
        id: rightSection
        anchors.right: parent.right
        spacing: 5

        //volume brightness
        Rectangle {
          height: 24
          width: brightContent.width + volContent.width + 30
          radius: 12
          color: root.theme.bgSurface

          Row {
            anchors.centerIn: parent
            spacing: 5

            // volume
            Rectangle{
              width: volContent.width
              height: volContent.height
              color: "transparent"
              Row {
                id: volContent
                anchors.verticalCenter: parent.verticalCenter
                spacing: 6

                Text {
                  text: {
                    const sink = Pipewire.defaultAudioSink;
                    if (!sink || !sink.audio || sink.audio.muted || sink.audio.volume <= 0) return "󰖁";
                    if (sink.audio.volume < 0.33) return "󰕿";
                    if (sink.audio.volume < 0.66) return "󰖀";
                    return "󰕾";
                  }
                  color: {
                    const sink = Pipewire.defaultAudioSink;
                    if (!sink || !sink.audio || sink.audio.muted) return root.theme.textMuted;
                    return root.theme.accentPrimary;
                  }
                  font.pixelSize: 12
                  font.family: root.font
                }

                Text {
                  anchors.verticalCenter: parent.verticalCenter
                  text: {
                    const sink = Pipewire.defaultAudioSink;
                    if (!sink || !sink.audio) return "–";
                    if (sink.audio.muted) return "Mute";
                    return Math.round(sink.audio.volume * 100) + "%";
                  }
                  color: root.theme.textPrimary
                  font.pixelSize: 10
                  font.family: root.font
                }
              }

              MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton
                onClicked: {
                  const sink = Pipewire.defaultAudioSink;
                  if (sink && sink.audio) sink.audio.muted = !sink.audio.muted;
                }
                onWheel: (wheel) => {
                  const sink = Pipewire.defaultAudioSink;
                  if (!sink || !sink.audio) return;
                  const delta = wheel.angleDelta.y > 0 ? 0.02 : -0.02;
                  sink.audio.volume = Math.max(0, Math.min(1.5, sink.audio.volume + delta));
                }
              }
            }

            // seperator     
            Rectangle {
              anchors.verticalCenter: parent.verticalCenter
              width: 1
              height: parent.height - 7
              color: "#45475a"
            }

            // Brightness
            Rectangle{
              width: brightContent.width
              height: brightContent.height
              color: "transparent"

              Row {
                id: brightContent
                spacing: 6
                
                Text {
                  anchors.verticalCenter: parent.verticalCenter
                  text: "󰃠"
                  color: root.theme.accentOrange
                  font.pixelSize: 12
                  font.family: root.font
                }

                Text {
                  anchors.verticalCenter: parent.verticalCenter
                  text: Math.round(root.brightnessValue * 100) + "%"
                  color: root.theme.textPrimary
                  font.pixelSize: 10
                  font.family: root.font
                }
              }

              MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onWheel: (wheel) => {
                  brightnessSetProc.command = wheel.angleDelta.y > 0 ? ["brightnessctl", "set", "5%+"] : ["brightnessctl", "set", "5%-"];
                  brightnessSetProc.running = true;
                }
              }
            }

          }
        }

        // Network, bluetooth
        Rectangle {
          height: 24
          width: netContent.width + 12
          radius: 12
          color: root.theme.bgSurface
          Accessible.role: Accessible.StaticText
          Accessible.name: {
            if (SystemInfo.networkType === "ethernet") return "Network: Ethernet"
            if (SystemInfo.networkType === "wifi") return "Network: WiFi " + SystemInfo.networkInfo
            return "Network: Disconnected"
          }

          Row {
            id: netContent
            anchors.centerIn: parent
            spacing: 6

            Text {
              text: SystemInfo.bluetoothStatus ? "" : "󰂯"
            }

            Text {
              anchors.verticalCenter: parent.verticalCenter
              text: {
                if (SystemInfo.networkType === "ethernet") return "󰈀"
                if (SystemInfo.networkType === "wifi") return "󰖩"
                return "󰖪"
              }
              color: SystemInfo.networkType === "disconnected" ? root.theme.textMuted : root.theme.accentGreen
              font.pixelSize: 14
              font.family: root.font
            }
            Text {
              anchors.verticalCenter: parent.verticalCenter
              text: SystemInfo.networkInfo
              color: root.theme.textPrimary
              font.pixelSize: 11
              font.family: root.font
            }
          }

          MouseArea {
            anchors.fill: parent
            onClicked: MenuState.togglePanel("wifi")
          }
        }

        // controll center
        Rectangle {
          height: 24
          width: (notification.visible ? notification.implicitWidth : 0) + (seperator.visible ? seperator.width : 0) +  power.implicitWidth + 2
          radius: 12
          color: root.theme.bgSurface

          Row {
            anchors.centerIn: parent

            // notitfication
            Rectangle {
              id: notification
              implicitHeight: 24
              implicitWidth: 24
              visible: MenuState.notificationPresent
              radius: 12
              color: "transparent"

              Text {
                anchors.centerIn: parent
                font.pixelSize: 13
                font.family: root.font
                text: "󰂚"
                color: theme.accentCyan
              }
            }

            // seperator
            Rectangle {
              id: seperator
              visible: MenuState.notificationPresent
              width: 1
              height: 14 
              y: 5
              color: "#45475a"
            }

            // poweroff
            Rectangle {
              id: power
              implicitHeight: 24
              implicitWidth: 24
              radius: 12
              color: "transparent"

              Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 13
                font.family: root.font
                text: "󰗼"
                color: theme.accentRed
              }
            }
          }
          MouseArea {
            anchors.fill: parent
            onClicked: MenuState.togglePanel("notification")
          }
        }

      }
    }
  }
}