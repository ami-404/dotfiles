-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function ()
  -- hl.exec_cmd(terminal)
  hl.exec_cmd("nm-applet --indicator")
  -- hl.exec_cmd("waybar & hyprpaper & firefox")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("awww-daemon")
  hl.exec_cmd("mpd")
  hl.exec_cmd("waybar")
  -- hl.exec_cmd("swaync")
  hl.exec_cmd("/usr/bin/gnome-keyring-daemon --start --components=secrets")
  hl.exec_cmd("qs -c my-shell")
  -- hl.exec_cmd("eww daemon")
  -- hl.exec_cmd("eww --config ~/.config/eww/clock_modern open wallpaper_clock")
  -- hl.exec_cmd("quickshell -c overview")
  -- hl.exec_cmd("quickshell -c powermenu")

  hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"')
  hl.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "catppuccin-mocha-blue-standard+default"')
  hl.exec_cmd('gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"')

end)
