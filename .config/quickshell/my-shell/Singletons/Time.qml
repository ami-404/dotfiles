pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root

  readonly property string hoursString: Qt.formatDateTime(clock.date, "hh")
  readonly property string minutesString: Qt.formatDateTime(clock.date, "mm")

  readonly property bool showColon: clock.date.getSeconds() % 2 === 0

  readonly property string timeString: {
    Qt.formatDateTime(clock.date, "hh:mm")
  }

  readonly property string dateString: {
    Qt.formatDateTime(clock.date, "ddd d")
  }

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
}
