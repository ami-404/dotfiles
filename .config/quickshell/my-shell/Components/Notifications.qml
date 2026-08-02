import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../Singletons"

import "../config.js" as Config

Scope {
  id: root
  property bool centerOpen: MenuState.notificationCenterOpen
  // centerOpen: 

  // property var debugInit: {
  //   console.log(JSON.stringify(Time));
  // }

  ListModel { id: history }

  NotificationServer {
    id: server
    actionsSupported: true
    bodySupported: true
    imageSupported: true

    onNotification: n => {
      history.insert(0, {
        summary: n.summary,
        body: n.body,
        appName: n.appName,
        urgency: n.urgency,
        time: Qt.formatDateTime(new Date(), "HH:mm")
      })
      n.tracked = true
    }
  }

  IpcHandler {
    target: "notifications"
    function toggle(): void { root.centerOpen = !root.centerOpen }
    function show(): void { root.centerOpen = true }
    function hide(): void { root.centerOpen = false }
  }


  // --- NOTIFICATION POPUP ---
  PanelWindow {
    anchors { top: true; right: true }
    margins { top: 30; right: 12 }

    implicitWidth: 380
    implicitHeight: Math.max(1, column.implicitHeight)
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    ColumnLayout {
      id: column
      width: parent.width
      spacing: 10

      Repeater {
        model: server.trackedNotifications
        delegate: Rectangle {
          id: card
          required property var modelData

          Timer {
            running: card.modelData.urgency !== NotificationUrgency.Critical
            interval: Config.notifications.timeout
            onTriggered: card.modelData.dismiss()
          }

          Layout.fillWidth: true
          Layout.preferredHeight: layout.implicitHeight + 20
          radius: 8
          color: Config.colors.bg
          border.width: 2
          border.color: modelData.urgency === NotificationUrgency.Critical ? Config.colors.red : Config.colors.purple

          RowLayout {
            id: layout
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Image {
              Layout.preferredWidth: 36
              Layout.preferredHeight: 36
              Layout.alignment: Qt.AlignTop
              fillMode: Image.PreserveAspectFit
              visible: source.toString() !== ""
              source: card.modelData.image || card.modelData.appIcon || ""
            }

            ColumnLayout {
              Layout.fillWidth: true
              spacing: 2

              Text {
                Layout.fillWidth: true
                text: card.modelData.summary
                color: Config.colors.cyan
                font.family: Config.bar.fontFamily
                font.pixelSize: Config.bar.fontSize
                font.bold: true
                elide: Text.ElideRight
              }

              Text {
                Layout.fillWidth: true
                visible: text !== ""
                text: card.modelData.body
                color: Config.colors.fg
                font.family: Config.bar.fontFamily
                font.pixelSize: Config.bar.fontSize - 1
                wrapMode: Text.WordWrap
              }
            }
          }

          MouseArea {
            anchors.fill: parent
            onClicked: card.modelData.dismiss()
          }
        }
      }
    }
  }


  // --- NOTIFICATION CENTER ---
  PanelWindow {
    visible: root.centerOpen
    anchors { top: true; right: true }
    margins { top: 30; right: 12 }
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    implicitWidth: 380
    
    // 1. Give it a fixed height instead of calculating it dynamically
    implicitHeight: history.count > 0 ? 600 : 40 // 600 

    Rectangle {
      anchors.fill: parent
      radius: 10
      color: Config.colors.bg
      border.width: 2
      border.color: Config.colors.purple

      ColumnLayout {
        id: centerMainCol
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        // quick controls 
        Column {
          // anchors.fill: parent
          spacing: 5
          visible: false
          // anchors.fill: parent

          Process {
            id: colorPicker
            command: ["hyprpicker", "-a"]
          }

          Process {
            id: camera
            command: ["snapshot"]
          }

          
          // Horizontal Rule acting as a separator
          Rectangle {
              width: parent.parent.width
              height: 1
              color: "#555555"
          }

          RowLayout {

            Rectangle {
              radius: 8
              width: 25
              height: 25
              border.color: "#555555"
              border.width: 1
              color: "Transparent"

              Text {
                text: ""
                color: "#cdd6f4"
                font.family: Config.bar.fontFamily
                anchors.centerIn: parent
              }

              MouseArea {
                anchors.fill: parent
                onClicked: {
                  root.centerOpen = false
                  colorPicker.running = true
                }
              }
            }

            Rectangle {
              radius: 8
              width: 25
              height: 25
              border.color: "#555555"
              border.width: 1
              color: "Transparent"

              Text {
                text: "󰄀"
                color: "#cdd6f4"
                font.family: Config.bar.fontFamily
                anchors.centerIn: parent
              }

              MouseArea {
                anchors.fill: parent
                onClicked: {
                  root.centerOpen = false
                  camera.running = true
                }
              }
            }

          }

          Slider {
          id: brightnessSlider
          anchors.fill: parent
          width: parent.parent.width
          from: 0
          to: 100
          value: 50 // Pull this dynamically from your system shell service

          onValueChanged: {
              // Executes brightnessctl to set the brightness percentage
              Process.run(["brightnessctl", "set", brightnessSlider.value + "%"])
            }
          }
        }

        // Header Row (Remains Unchanged)
        RowLayout {
          Layout.fillWidth: true

          Text {
            Layout.fillWidth: true
            text: "Notifications"
            color: Config.colors.cyan
            font.family: Config.bar.fontFamily
            font.pixelSize: Config.bar.fontSize + 2
            font.bold: true
          }
          
          Text {
            text: "Clear all"
            visible: history.count > 0
            color: Config.colors.red
            font.family: Config.bar.fontFamily
            font.pixelSize: Config.bar.fontSize - 1
            MouseArea {
              anchors.fill: parent
              onClicked: history.clear()
            }
          }
        }

        

        // 2. Scrollable ListView
        ListView {
          id: listView
          Layout.fillWidth: true
          Layout.fillHeight: true // Takes up all remaining space below the header
          clip: true              // Prevents notifications from drawing outside the list
          spacing: 10
          
          model: history

          delegate: Rectangle {
            id: historyCard
            
            // 3. Fix Layout properties for ListView constraints
            width: ListView.view.width 
            implicitHeight: cardCol.implicitHeight + 20 
            
            radius: 8
            color: Config.colors.bg
            border.width: 2
            border.color: model.urgency === NotificationUrgency.Critical ? Config.colors.red : Config.colors.purple

            ColumnLayout {
              id: cardCol
              anchors.fill: parent
              anchors.margins: 8
              spacing: 2

              RowLayout {
                Layout.fillWidth: true
                spacing: 6

                Text {
                  Layout.fillWidth: true
                  text: model.summary
                  color: Config.colors.fg
                  font.family: Config.bar.fontFamily
                  font.pixelSize: Config.bar.fontSize
                  font.bold: true
                  elide: Text.ElideRight
                }
                Text {
                  text: model.time
                  color: Config.colors.muted
                  font.family: Config.bar.fontFamily
                  font.pixelSize: Config.bar.fontSize - 3
                }
                Text {
                  text: "x"
                  color: Config.colors.muted
                  font.family: Config.bar.fontFamily
                  font.pixelSize: Config.bar.fontSize - 1
                  MouseArea {
                    anchors.fill: parent
                    onClicked: history.remove(index)
                  }
                }
              }

              Text {
                Layout.fillWidth: true
                visible: text !== ""
                text: model.body
                color: Config.colors.fg
                font.family: Config.bar.fontFamily
                font.pixelSize: Config.bar.fontSize - 1
                wrapMode: Text.WordWrap
              }

              Text {
                visible: model.appName !== ""
                text: model.appName
                color: Config.colors.muted
                font.family: Config.bar.fontFamily
                font.pixelSize: Config.bar.fontSize - 3
              }
            }
          }
        }
      }
    }
  }
}
