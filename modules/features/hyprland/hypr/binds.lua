local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- App binds
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("$TERMINAL"), { description = "Open Terminal" })
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("$LAUNCHER"), { description = "Open Launcher" })
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("$SELECT_WALLPAPER"), { description = "Select Wallpaper" })
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("$LOCKSCREEN"), { description = "Lock screen" })
-- hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd("view-binds"), { description = "View Keybinds" })

-- Screenshots
hl.bind("PRINT", hl.dsp.exec_cmd("$SCREENSHOT_AREA"), { description = "Screenshot Area" })
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("$SCREENSHOT_SCREEN"), { description = "Screenshot Screen" })
hl.bind("CTRL + PRINT", hl.dsp.exec_cmd("$SCREENSHOT_WINDOW"), { description = "Screenshot Window" })

-- Window
hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { description = "Close Active Window" })
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exit(), { description = "Exit Hyprland" })
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle Floating" })
hl.bind(
  mainMod .. " + F",
  hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }),
  { description = "Fullscreen" }
)
hl.bind(
  mainMod .. " + M",
  hl.dsp.window.fullscreen({ mode = "maximize", action = "toggle" }),
  { description = "Maximize" }
)
-- hl.bind(mainMod .. " + P", hl.dsp.window.pseudo(), { description = "Pseudo Tiling" })
hl.bind(mainMod .. " + tab", hl.dsp.window.cycle_next(), { description = "Cycle Next Window" })
hl.bind(mainMod .. " + SHIFT + tab", hl.dsp.window.cycle_next({ next = "prev" }), { description = "Cycle Previous Window" })
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }), { description = "Move Focus Left" })
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }), { description = "Move Focus Down" })
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }), { description = "Move Focus Up" })
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }), { description = "Move Focus Right" })
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.swap({ direction = "left" }), { description = "Move Window Left" })
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "down" }), { description = "Move Window Down" })
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "up" }), { description = "Move Window Up" })
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.swap({ direction = "right" }), { description = "Move Window Right" })

-- Scrolling layout column resize
-- hl.bind(mainMod .. " + bracketright", hl.dsp.layout("colresize +conf"), { description = "Expand Column" })
-- hl.bind(mainMod .. " + bracketleft", hl.dsp.layout("colresize -conf"), { description = "Shrink Column" })

-- Workspaces
-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }), { description = "Switch to Workspace " .. i })
  hl.bind(
    mainMod .. " + SHIFT + " .. key,
    hl.dsp.window.move({ workspace = i }),
    { description = "Move to Workspace " .. i }
  )
end

-- Scratchpad
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"), { description = "Toggle Scratchpad" })
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }),
  { description = "Move to Scratchpad" })

-- Resize windows with arrow keys
hl.bind(mainMod .. " + right", hl.dsp.window.resize({ x = 10, y = 0 }), { repeating = true })
hl.bind(mainMod .. " + left",  hl.dsp.window.resize({ x = -10, y = 0 }), { repeating = true })
hl.bind(mainMod .. " + up",    hl.dsp.window.resize({ x = 0, y = -10 }), { repeating = true })
hl.bind(mainMod .. " + down",  hl.dsp.window.resize({ x = 0, y = 10 }), { repeating = true })

-- Move/resize windows with mainMod + LMB/RMB and dragging
-- hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
-- hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

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
