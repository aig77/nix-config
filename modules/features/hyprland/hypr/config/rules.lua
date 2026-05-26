-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },
	move = "20 monitor_h-120",
	float = true,
})

-- Bitwarden
hl.window_rule({ name = "bitwarden-float", match = { class = "Bitwarden" }, float = true, size = "1000 750", no_screen_share = true })

-- Bluetooth / Audio / Network
hl.window_rule({ name = "blueman-float", match = { class = ".*blueman.*" }, float = true, size = "800 600" })
hl.window_rule({ name = "pavucontrol-float", match = { class = ".*pavucontrol.*" }, float = true, size = "800 600" })
hl.window_rule({ name = "nm-float", match = { class = "nm-connection-editor" }, float = true })

-- Gaming (workspace 4)
hl.window_rule({ name = "steam-game-ws", match = { class = "steam_app_.*" }, fullscreen = true, workspace = "4" })
hl.window_rule({ name = "game-content-ws", match = { content = "game" }, fullscreen = true, workspace = "4" })
hl.window_rule({ name = "gamescope-ws", match = { class = "gamescope" }, fullscreen = true, workspace = "4" })

-- Browser idle inhibit
hl.window_rule({ name = "zen-yt-idle", match = { class = ".*zen.*", title = ".*YouTube.*" }, idle_inhibit = "focus" })
hl.window_rule({ name = "zen-idle", match = { class = ".*zen.*" }, idle_inhibit = "fullscreen" })

-- Misc float
hl.window_rule({ name = "waypaper-float", match = { class = "waypaper" }, float = true, center = true, size = "1000 750" })
hl.window_rule({ name = "calculator-float", match = { title = "Calculator" }, float = true })
hl.window_rule({ name = "screenshare-picker", match = { title = "^(Select what to share)$" }, float = true, size = "800 600" })

-- Layer rules
hl.layer_rule({ name = "launcher-blur", match = { namespace = "launcher" }, blur = true })
hl.layer_rule({ name = "launcher-alpha", match = { namespace = "launcher" }, ignore_alpha = 0.5 })
hl.layer_rule({ name = "qs-launcher-blur", match = { namespace = "^(quickshell:launcher)$" }, blur = true })
hl.layer_rule({ name = "qs-launcher-alpha", match = { namespace = "^(quickshell:launcher)$" }, ignore_alpha = 0.1 })

-- Disable Hyprland layer animations for all quickshell surfaces so the
-- layersOut slide does not ghost after the session lock releases.
hl.layer_rule({ name = "qs-cc-noanim",            match = { namespace = "^(quickshell:controlcenter)$"            }, no_anim = true })
hl.layer_rule({ name = "qs-cc-scrim-noanim",      match = { namespace = "^(quickshell:controlcenter:scrim)$"       }, no_anim = true })
hl.layer_rule({ name = "qs-cc-popup-noanim",      match = { namespace = "^(quickshell:controlcenter:notifdetail)$" }, no_anim = true })
hl.layer_rule({ name = "qs-cc-power-noanim",      match = { namespace = "^(quickshell:controlcenter:powerconfirm)$"}, no_anim = true })
hl.layer_rule({ name = "qs-pill-noanim",          match = { namespace = "^(quickshell:workspacepill)$"            }, no_anim = true })
hl.layer_rule({ name = "qs-notifications-noanim", match = { namespace = "^(quickshell:notifications)$"            }, no_anim = true })
hl.layer_rule({ name = "qs-overview-noanim",      match = { namespace = "^(quickshell:overview)$"                 }, no_anim = true })
