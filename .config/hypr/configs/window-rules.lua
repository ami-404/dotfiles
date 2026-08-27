--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})



hl.window_rule({match = {class = ".*"}, persistent_size = 1})
-- commented out to prevent godot debug menu being not focused
-- hl.window_rule({match = {xwayland = 1, float = 1, fullscreen = 0, pin = 0}, no_focus = 1})

hl.window_rule({match = {class = ".*nm-connection-editor.*"}, float = 1})
hl.window_rule({match = {class = "org.gnome.Calculator"}, float = 1})
hl.window_rule({match = {class = "org.gnome.Cheese"}, float = 1, size = {505, 625}})
hl.window_rule({match = {class = "org.gnome.Snapshot"}, float = 1, size = {505, 625}})

hl.window_rule({match = {class = ".*thunar.*", title = ".*Rename.*"}, float = 1})
hl.window_rule({match = {class = ".*thunar.*", title = ".*File Operation Progress.*"}, float = 1})
hl.window_rule({match = {class = "Tk"}, float = 1})
hl.window_rule({match = {class = "mpv"}, float = 1})
hl.window_rule({match = {class = "vlc"}, float = 1})
hl.window_rule({match = {class = "firefox", title = "Picture-in-Picture"}, float = 1})
hl.window_rule({match = {class = "librewolf", title = "Picture-in-Picture"}, float = 1})
hl.window_rule({match = {title = ".*Open File.*"}, float = 1})
hl.window_rule({match = {class = "xdg-desktop-portal-gtk"}, float = 1})

hl.window_rule({match = {class = "org.kde.ark"}, float = 1})
hl.window_rule({match = {class = "feh"}, float = 1, size = {740, 416}, move = {313,187}})

hl.window_rule({match = {initial_class = "org.godotengine.ProjectManager", initial_title = "Godot"}, float = 1, size = {864, 600}})
hl.window_rule({match = {initial_title = "Godot"}, float = 1})
hl.window_rule({match = {class = "org.godotengine.Editor", initial_title = "Godot"}, tile = 1})

hl.window_rule({match = {class = "brave-browser", title = ".*Sign in.*"}, float = 1})
hl.window_rule({match = {class = "helium", title = ".*Sign in.*"}, float = 1})

hl.window_rule({match = {class = "org.kde.gwenview"}, float = 1})

hl.window_rule({match = {title = ".*Save File.*"}, float = 1})

hl.window_rule({match = {class = "orbitor.exe", title = ".*Orbiter Server Launchpad.*"}, float = 1})

hl.window_rule({match = {class = "org.kde.okular"}, float = 1})
hl.window_rule({match = {class = "org.freedesktop.impl.portal.desktop.kde"}, float = 1})

hl.layer_rule({match = {namespace = "noctalia-background-.*"}, ignore_alpha = 0.5, blur = true, blur_popups = true})

-- layerrule {
--   name = noctalia
--   match:namespace = noctalia-background-.*$
--   ignore_alpha = 0.5
--   blur = true
--   blur_popups = true
-- }
-- hl.window_rule({match = {class = "org.gnome.Cheese"}, float = 1, size = (505,625)})

-- hl.window_rule({
--   name = "persist",
--   match = {class = ".*"},
--   persistent_size = 1,
-- })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

