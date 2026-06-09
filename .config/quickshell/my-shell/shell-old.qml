import Quickshell
import QtQuick
import Quickshell.Io
import "powermenu" as PowerMenu
import "overview" as Overview
import "clock"  as Clock
import "launcher" as Launcher
import "wallpaper"  as Wallpaper
// import "activatelinux" as ActivateLinux

// import Quickshell
// import Quickshell.Io
// import Quickshell.Wayland
// import Quickshell.Widgets
// import QtQuick
// import QtQuick.Controls
// import QtQuick.Layouts

ShellRoot {
  id: root
    // Every windows run under this single process, sharing memory space!

    Clock.Clock {
      id: clock
    }

    property bool launcherActive: false
    property bool wallpaperActive: false

    IpcHandler {
      target: "launcher"

      function toggle(): void {
        root.launcherActive = !root.launcherActive
      }
    }

    IpcHandler {
      target: "wallpaper"

      function toggle(): void {
        root.wallpaperActive = !root.wallpaperActive;
      }
    }

      // if (wallpaperPanel.visible) {
      //   root.searchText = "";
      //   root.previewPath = "";
      //   searchInput.forceActiveFocus();
      //   if (WallpaperService.wallpapers.length === 0) WallpaperService.rescan();
      // }

    PowerMenu.PowerMenuWindow {
        id: powermenu
    }

    Overview.OverviewWindow {
        id: overview
    }

    LazyLoader {
      id: applauncher
      active: root.launcherActive
      component: Launcher.AppLauncher {
        onEscapePressed: root.launcherActive = false
      }
    }

    // Connections {
    // // Target the actual instantiated object. 
    // // Quickshell automatically populates 'item' when active is true.
    // target: applauncher.item
    //
    // // Catch the signal using modern Qt6 function syntax
    // function onEscapePressed() {
    //     root.launcherActive = false
    //   }
    // }

    LazyLoader {
      id: wallpaper
      active: root.wallpaperActive
      component: Wallpaper.WallpaperManager {
        onEscapePressed: root.wallpaperActive = false
      }
    }

    // Connections {
    // target: wallpaper.item
    //
    // function onEscapePressed() {
    //     root.wallpaperActive = false
    //   }
    // }

              //     Keys.onEscapePressed: {
              //   if (root.previewPath !== "") {
              //     root.previewPath = "";
              //   } else {
              //     wallpaperPanel.visible = false;
              //   }
              // }


    // ActivateLinux.ActivateLinux {
    //   id: activate
    // }
}
