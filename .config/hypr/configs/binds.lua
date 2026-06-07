---------------------
---- KEYBINDINGS ----
---------------------

-- ---@meta
-- terminal = terminal
-- fileManager = fileManager
-- menu = menu

local mainMod = "SUPER"
local mod = "CTRL + SUPER"
local ctsh = "CTRL + SHIFT"

-- terminal
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + CTRL + Return", hl.dsp.exec_cmd(terminal .. " -e tmux new-session"))
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd("[float; size 600 400; center] " .. terminal))

-- apps
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
-- hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(brave))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(helium))
hl.bind(mainMod .. " + CTRL + B", hl.dsp.exec_cmd(firefox))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("pkill -x waybar || waybar"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("rofi -show emoji"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("gnome-calculator"))

-- launcher
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + CTRL + SPACE", hl.dsp.exec_cmd("dotfiles/.config/rofi/launchers/type-6/launcher.sh"))

-- Wallpapers
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("~/scripts/change-wal.sh"))
hl.bind(mainMod .. " + SHIFT + Y", hl.dsp.exec_cmd("~/Pictures/wallpapers/wal-picker.sh"))

-- logout
hl.bind(
	mainMod .. " + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"),
	{ long_press = true }
)
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("wlogout"), { release = true })
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"), { long_press = true })

-- window actions
local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
closeWindowBind:set_enabled(true)
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + C", function()
	hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
	hl.dispatch(hl.dsp.window.resize({ x = 600, y = 400 }))
	hl.dispatch(hl.dsp.window.center())
end)

-- Zoom in
hl.bind(mainMod .. " + mouse_down", function()
    local current_zoom = tonumber(hl.get_config("cursor.zoom_factor")) or 1.0
    hl.config({ cursor = { zoom_factor = current_zoom + 0.3 } })
end)

-- Zoom out
hl.bind(mainMod .. " + mouse_up", function()
    local current_zoom = tonumber(hl.get_config("cursor.zoom_factor")) or 1.0
    -- Note: I corrected the logic here. Your previous jq script (`[.float + 1.0, 1.0] | min`) 
    -- was accidentally resetting the zoom to 1.0 instead of decrementing it. 
    -- We now subtract 1.0 and use math.max to prevent zooming out past the default 1.0 scale.
    hl.config({ cursor = { zoom_factor = math.max(current_zoom - 0.5, 1.0) } })
end)

-- Reset (Middle click)
hl.bind(mainMod .. " + mouse:274", function()
    hl.config({ cursor = { zoom_factor = 1.0 } })
end)


-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Cycles focus AND brings the window to the top
hl.bind(mainMod .. " + Tab", function ()
  hl.dispatch(hl.dsp.window.cycle_next())
  hl.dispatch(hl.dsp.window.bring_to_top())
end)

-- toggle overview
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.exec_cmd("qs -c my-shell ipc call overview toggle"))

-- Workspace switching
hl.bind(mainMod .. " + CTRL + right", hl.dsp.focus({ workspace = "+1" }))

hl.bind(mainMod .. " + CTRL + left", hl.dsp.focus({ workspace = "-1" }))

hl.bind(mainMod .. " + CTRL + bracketright", hl.dsp.focus({ workspace = "+1" }))

hl.bind(mainMod .. " + CTRL + bracketleft", hl.dsp.focus({ workspace = "-1" }))


-- Move workspace relative
hl.bind(mainMod .. " + SHIFT + bracketright",
    hl.dsp.window.move({ workspace = "+1" })
)

hl.bind(mainMod .. " + SHIFT + bracketleft",
    hl.dsp.window.move({ workspace = "-1" })
)

hl.bind(mainMod .. " + CTRL + SHIFT + bracketright",
    hl.dsp.window.move({ workspace = "+1", follow = false })
)

hl.bind(mainMod .. " + CTRL + SHIFT + bracketleft",
    hl.dsp.window.move({ workspace = "-1", follow = false })
)

hl.bind(mainMod .. " + CTRL + SHIFT + right",
    hl.dsp.window.move({ workspace = "+1", follow = false })
)

hl.bind(mainMod .. " + CTRL + SHIFT + left",
    hl.dsp.window.move({ workspace = "-1" , follow = false})
)

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + CTRL + " .. key, function()
		hl.dsp.window.move({ workspace = i })
		hl.dsp.focus({ workspace = i })
	end)
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", function()
	local win = hl.get_active_window()
	if win == nil then
		return
	end

	local special_active = hl.get_active_special_workspace()

	if special_active ~= nil then
		hl.dispatch(hl.dsp.window.move({ workspace = "r+0" }))
	else
		hl.dispatch(hl.dsp.window.move({ workspace = "special:magic" }))
	end
end)

-- Scroll through existing workspaces with mainMod + scroll
-- hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
-- hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Screenshots
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m output -m active -o ~/Pictures/Screenshots"))

hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m window -o ~/Pictures/Screenshots"))

hl.bind("CTRL + SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m region -o ~/Pictures/Screenshots"))



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


-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
