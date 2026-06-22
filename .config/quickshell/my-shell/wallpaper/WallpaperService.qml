pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property list<string> wallpapers: []
  property string currentWallpaper: ""
  property string backend: "awww"
  // property var transition: []


  readonly property string cachePath: Quickshell.env("HOME") + "/.cache/quickshell/wallpapers.cache"

  // Scan wallpaper directories
  Process {
    id: scanner
    command: []
    // command: ["sh", "-c", // ~/Pictures
    //   "find ~/Pictures/wallpapers -maxdepth 2 -type f \\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.gif' \\) 2>/dev/null | sort -u | head -200"
    // ]
    running: false
    stdout: SplitParser {
      onRead: data => {
        const path = data.trim();
        if (path !== "") {
          root.wallpapers = [...root.wallpapers, path];
        }
      }
    }
  }

  // Load saved wallpaper path
  FileView {
    id: configFile
    path: Quickshell.env("HOME") + "/.config/quickshell/my-shell/wallpaper/wallpaper.conf"
    onTextChanged: {
      const saved = configFile.text().trim();
      if (saved !== "") root.currentWallpaper = saved;
    }
  }

  Component.onCompleted: {

    // property string type: "outer"

    scanner.command = [
      "sh", "-c",
      "CACHE=\"" + root.cachePath + "\"; " +
      "if [ -s \"$CACHE\" ]; then " +
      "  cat \"$CACHE\"; " +
      "else " +
      "  mkdir -p \"$(dirname \"$CACHE\")\" && " +
      "  find ~/Pictures/wallpapers -maxdepth 2 -type f \\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.gif' \\) 2>/dev/null | sort -u | head -200 | tee \"$CACHE\"; " +
      "fi"
    ];
    scanner.running = true;
  }

  function rescan() {
   if (scanner.running) return;
    
    wallpapers = [];

    scanner.command = [
      "sh", "-c",
      "CACHE=\"" + root.cachePath + "\"; " +
      "mkdir -p \"$(dirname \"$CACHE\")\" && " +
      "find ~/Pictures/wallpapers -maxdepth 2 -type f \\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.gif' \\) 2>/dev/null | sort -u | head -200 | tee \"$CACHE\""
    ];
    scanner.running = true;
  }

  // function setTransition() {
  //   root.transition = ["--transition-type", "grow", "--transition-pos", "center", "--transition-duration", "1"] ...root.transition
  // }

  function setWallpaper(path) {
    currentWallpaper = path;
    // setTransition()

    setProcess.command = ["awww", "img", "--transition-type", "random", path];
    setProcess.running = true;

    setThemeProcess.command = ["wallust", "run", path, "-s"]
    setThemeProcess.running = true

    // Save to config
    saveProcess.command = ["sh", "-c", 'printf "%s" "$1" > "$HOME/.config/quickshell/wallpaper.conf"', "sh", path];
    saveProcess.running = true;
  }

  Process {
    id: setProcess
    command: []
    running: false
  }

  Process {
    id: setThemeProcess
    command: []
    running: false
  }

  Process {
    id: saveProcess
    command: []
    running: false
  }
}
