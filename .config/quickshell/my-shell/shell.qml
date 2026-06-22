import Quickshell
import QtQuick
import Quickshell.Io
import "powermenu" as PowerMenu
import "overview" as Overview
import "clock"  as Clock
import "launcher" as Launcher
import "wallpaper"  as Wallpaper
import "notification" as Notification
// import "activatelinux" as ActivateLinux
import "config.js" as Config

ShellRoot {
    // Every windows run under this single process, sharing memory space!

    Clock.Clock {
      id: clock
    }

    Notification.Notifications {
      id: notification
    }

    Launcher.AppLauncher {
      id : launcher
    }

    PowerMenu.PowerMenuWindow { id: powermenu }

    Overview.OverviewWindow {
        id: overview
    }

    Wallpaper.WallpaperManager {
      id : wallpaper
    }

    // ActivateLinux.ActivateLinux {
    //   id: activate
    // }
}
