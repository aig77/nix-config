-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

-- Propagate Hyprland's environment to the systemd user session early,
-- so services like hypridle can start cleanly on hyprland.start.
hl.exec_cmd("dbus-update-activation-environment --systemd --all")
hl.exec_cmd("systemctl --user import-environment")

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("NIXOS_OZONE_WL", "1")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("GDK_BACKEND", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
