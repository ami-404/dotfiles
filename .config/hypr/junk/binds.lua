---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"
local mod = "CTRL + SUPER"
local ctsh = "CTRL + SHIFT"

-- Terminal
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + CTRL + Return", hl.dsp.exec_cmd(terminal .. " -e tmux new-session"))
hl.bind(mainMod .. " + SHIFT + Return",
    hl.dsp.exec_cmd("[float; size 600 400; center] " .. terminal)
)

-- Window actions
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())

-- Exit / logout
hl.bind(mainMod .. " + M",
    hl.dsp.exec_cmd("wlogout"),
    { release = true }
)

-- Apps
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(brave))
hl.bind(mod .. " + B", hl.dsp.exec_cmd(firefox))

-- Launcher
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + A",
    hl.dsp.exec_cmd("~/.config/rofi/type-7/launcher.sh")
)

-- Lock screen
hl.bind(mainMod .. " + L",
    hl.dsp.exec_cmd("hyprlock"),
    { release = true }
)

-- Tmux / terminal
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("tmux"))

-- Waybar
hl.bind(mainMod .. " + SHIFT + W",
    hl.dsp.exec_cmd("~/.config/hypr/scripts/start.sh")
)

hl.bind(mainMod .. " + W",
    hl.dsp.exec_cmd("pkill -x waybar || waybar")
)

-- Wallpapers
hl.bind(mainMod .. " + Y",
    hl.dsp.exec_cmd("~/.config/hypr/scripts/change-wal.sh")
)

hl.bind(mainMod .. " + SHIFT + Y",
    hl.dsp.exec_cmd("~/Pictures/wallpapers/wal-picker.sh")
)

-- Music
hl.bind(mainMod .. " + I",
    hl.dsp.exec_cmd("kitty ncmpcpp")
)

-- Emoji / calculator
hl.bind(mainMod .. " + SHIFT + E",
    hl.dsp.exec_cmd("rofi -show emoji")
)

hl.bind(mainMod .. " + SHIFT + C",
    hl.dsp.exec_cmd("gnome-calculator")
)

-- Floating centered terminal
hl.bind(mainMod .. " + C",
    hl.dsp.exec_cmd(
        "hyprctl dispatch togglefloating && " ..
        "hyprctl dispatch resizeactive exact 600 400 && " ..
        "hyprctl dispatch centerwindow"
    )
)

-- Special workspace
hl.bind(mainMod .. " + U",
    hl.dsp.workspace.toggle_special()
)

hl.bind(mainMod .. " + SHIFT + U",
    hl.dsp.window.move({ workspace = "special" })
)

-- Scratchpad
hl.bind(mainMod .. " + S",
    hl.dsp.workspace.toggle_special("magic")
)

hl.bind(mainMod .. " + SHIFT + S",
    hl.dsp.window.move({ workspace = "special:magic" })
)

-- Screenshots
hl.bind("PRINT",
    hl.dsp.exec_cmd("hyprshot -m output -m active -o ~/Pictures/Screenshots")
)

hl.bind("SHIFT + PRINT",
    hl.dsp.exec_cmd("hyprshot -m window -o ~/Pictures/Screenshots")
)

hl.bind(ctsh .. " + PRINT",
    hl.dsp.exec_cmd("hyprshot -m region -o ~/Pictures/Screenshots")
)

--------------------
---- FOCUS KEYS ----
--------------------

hl.bind(mainMod .. " + left",
    hl.dsp.focus({ direction = "left" })
)

hl.bind(mainMod .. " + right",
    hl.dsp.focus({ direction = "right" })
)

hl.bind(mainMod .. " + up",
    hl.dsp.focus({ direction = "up" })
)

hl.bind(mainMod .. " + down",
    hl.dsp.focus({ direction = "down" })
)

hl.bind(mainMod .. " + H",
    hl.dsp.focus({ direction = "left" })
)

hl.bind(mainMod .. " + L",
    hl.dsp.focus({ direction = "right" })
)

hl.bind(mainMod .. " + K",
    hl.dsp.focus({ direction = "up" })
)

hl.bind(mainMod .. " + J",
    hl.dsp.focus({ direction = "down" })
)

------------------------
---- WORKSPACES ----
------------------------

-- Workspace switching
hl.bind(mod .. " + right",
    hl.dsp.focus({ workspace = "+1" })
)

hl.bind(mod .. " + left",
    hl.dsp.focus({ workspace = "-1" })
)

hl.bind(mod .. " + bracketright",
    hl.dsp.focus({ workspace = "+1" })
)

hl.bind(mod .. " + bracketleft",
    hl.dsp.focus({ workspace = "-1" })
)

-- Number workspaces
for i = 1, 10 do
    local key = i % 10

    hl.bind(mainMod .. " + " .. key,
        hl.dsp.focus({ workspace = i })
    )

    hl.bind(mainMod .. " + SHIFT + " .. key,
        hl.dsp.window.move({ workspace = i })
    )
end

-- Move workspace relative
hl.bind(mainMod .. " + SHIFT + bracketright",
    hl.dsp.window.move({ workspace = "+1" })
)

hl.bind(mainMod .. " + SHIFT + bracketleft",
    hl.dsp.window.move({ workspace = "-1" })
)

hl.bind(mod .. " + SHIFT + right",
    hl.dsp.window.move({ workspace = "+1" })
)

hl.bind(mod .. " + SHIFT + left",
    hl.dsp.window.move({ workspace = "-1" })
)

------------------------
---- MOUSE ACTIONS ----
------------------------

hl.bind(mainMod .. " + mouse_down",
    hl.dsp.focus({ workspace = "e+1" })
)

hl.bind(mainMod .. " + mouse_up",
    hl.dsp.focus({ workspace = "e-1" })
)

hl.bind(mainMod .. " + mouse:272",
    hl.dsp.window.drag(),
    { mouse = true }
)

hl.bind(mainMod .. " + mouse:273",
    hl.dsp.window.resize(),
    { mouse = true }
)

------------------------
---- MEDIA KEYS ----
------------------------

-- Brightness
hl.bind("ALT + F2",
    hl.dsp.exec_cmd("brightnessctl set 5%-")
)

hl.bind("ALT + F3",
    hl.dsp.exec_cmd("brightnessctl set 5%+")
)

-- Player controls
hl.bind("ALT + F5",
    hl.dsp.exec_cmd('sh -c "playerctl play-pause ; mpc toggle"'),
    { locked = true }
)

hl.bind("CTRL + ALT + LEFT",
    hl.dsp.exec_cmd("playerctl previous"),
    { locked = true }
)

hl.bind("CTRL + ALT + RIGHT",
    hl.dsp.exec_cmd("playerctl next"),
    { locked = true }
)

-- Audio
hl.bind("ALT + F6",
    hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"),
    { locked = true }
)

hl.bind("ALT + F7",
    hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -2%"),
    { locked = true, repeating = true }
)

hl.bind("ALT + F8",
    hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +2%"),
    { locked = true, repeating = true }
)

------------------------
---- XF86 KEYS ----
------------------------

hl.bind("XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true }
)

hl.bind("XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true }
)

hl.bind("XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true }
)

hl.bind("XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true }
)

hl.bind("XF86MonBrightnessUp",
    hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),
    { locked = true, repeating = true }
)

hl.bind("XF86MonBrightnessDown",
    hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),
    { locked = true, repeating = true }
)

-- Playerctl
hl.bind("XF86AudioNext",
    hl.dsp.exec_cmd("playerctl next"),
    { locked = true }
)

hl.bind("XF86AudioPause",
    hl.dsp.exec_cmd("playerctl play-pause"),
    { locked = true }
)

hl.bind("XF86AudioPlay",
    hl.dsp.exec_cmd("playerctl play-pause"),
    { locked = true }
)

hl.bind("XF86AudioPrev",
    hl.dsp.exec_cmd("playerctl previous"),
    { locked = true }
)
