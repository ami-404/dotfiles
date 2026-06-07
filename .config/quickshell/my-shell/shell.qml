
import Quickshell
import QtQuick
import "powermenu" as PowerMenu
import "overview" as Overview
import "clock" as Clock
// import "activatelinux" as ActivateLinux

ShellRoot {
    // Both windows run under this single process, sharing memory space!
    
    PowerMenu.PowerMenuWindow {
        id: powermenu
    }

    Overview.OverviewWindow {
        id: overview
    }

    Clock.Clock {
      id: clock
    }

    // ActivateLinux.ActivateLinux {
    //   id: activate
    // }
}
