local shell = os.getenv("HYPR_SHELL") or "quickshell"
local mod = "SUPER"
local bind = hl.bind
local exec = hl.dsp.exec_cmd
local win = hl.dsp.window
local focus = hl.dsp.focus
local ws = hl.dsp.workspace
local layout = hl.dsp.layout

-- Apps
-- bind(mod .. " + slash", exec("view-binds"), { description = "View Keybinds" })
bind(mod .. " + RETURN", exec("$TERMINAL"), { description = "Open Terminal" })
bind(mod .. " + SPACE", exec("$LAUNCHER"), { description = "Open Launcher" })
bind(mod .. " + W", exec("$SELECT_WALLPAPER"), { description = "Select Wallpaper" })
bind(mod .. " + C", exec("$LOCKSCREEN"), { description = "Lock Screen" })

-- Screenshots
bind("PRINT", exec("$SCREENSHOT_AREA"), { description = "Screenshot Area" })
bind("SHIFT+PRINT", exec("$SCREENSHOT_SCREEN"), { description = "Screenshot Screen" })
bind("CTRL+PRINT", exec("$SCREENSHOT_WINDOW"), { description = "Screenshot Window" })

-- Window management
bind(mod .. " + Q", win.close(), { description = "Close Window" })
bind(mod .. " + SHIFT + Q", hl.dsp.exit(), { description = "Exit Hyprland" })
bind(mod .. " + T", win.float({ action = "toggle" }), { description = "Toggle Floating" })
bind(mod .. " + F", win.fullscreen({ mode = "fullscreen", action = "toggle" }), { description = "Fullscreen" })
bind(mod .. " + M", win.fullscreen({ mode = "maximized", action = "toggle" }), { description = "Maximize" })
bind(mod .. " + tab", win.cycle_next(), { description = "Cycle Next" })
bind(mod .. " + SHIFT + tab", win.cycle_next({ next = "prev" }), { description = "Cycle Prev" })

-- Focus
bind(mod .. " + H", focus({ direction = "left" }), { description = "Focus Left" })
bind(mod .. " + J", focus({ direction = "down" }), { description = "Focus Down" })
bind(mod .. " + K", focus({ direction = "up" }), { description = "Focus Up" })
bind(mod .. " + L", focus({ direction = "right" }), { description = "Focus Right" })

-- Move windows
bind(mod .. " + SHIFT + H", win.swap({ direction = "left" }), { description = "Move Window Left" })
bind(mod .. " + SHIFT + J", win.swap({ direction = "down" }), { description = "Move Window Down" })
bind(mod .. " + SHIFT + K", win.swap({ direction = "up" }), { description = "Move Window Up" })
bind(mod .. " + SHIFT + L", win.swap({ direction = "right" }), { description = "Move Window Right" })

-- Scrolling layout
if LAYOUT == "scrolling" then
  bind(mod .. " + bracketright", layout("colresize +conf"), { description = "Expand Column" })
  bind(mod .. " + bracketleft", layout("colresize -conf"), { description = "Shrink Column" })
  bind(mod .. " + comma", layout("consume_or_expel next"), { description = "Consume or Expel Into Column" })
end

-- Workspaces
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  bind(mod .. " + " .. key, focus({ workspace = i }), { description = "Switch to Workspace " .. i })
  bind(mod .. " + SHIFT + " .. key, win.move({ workspace = i }), { description = "Move to Workspace " .. i })
end

-- Shell-specific
if shell == "quickshell" then
  bind("ALT + tab", exec("qs ipc call overview toggle"), { description = "Workspace Overview" })
  bind(mod .. " + escape", exec("qs ipc call controlcenter toggle"), { description = "Control Center" })
end

-- Scratchpad
bind(mod .. " + S", ws.toggle_special("magic"), { description = "Toggle Scratchpad" })
bind(mod .. " + SHIFT + S", win.move({ workspace = "special:magic" }), { description = "Move to Scratchpad" })

-- Resize
bind(mod .. " + right", win.resize({ x = 10, y = 0 }), { repeating = true, description = "Resize Right" })
bind(mod .. " + left", win.resize({ x = -10, y = 0 }), { repeating = true, description = "Resize Left" })
bind(mod .. " + up", win.resize({ x = 0, y = -10 }), { repeating = true, description = "Resize Up" })
bind(mod .. " + down", win.resize({ x = 0, y = 10 }), { repeating = true, description = "Resize Down" })

-- Volume
bind("XF86AudioRaiseVolume", exec("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true, description = "Volume Up" })
bind("XF86AudioLowerVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true, description = "Volume Down" })
bind("XF86AudioMute", exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true, description = "Mute Audio" })
bind("XF86AudioMicMute", exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true, description = "Mute Microphone" })

-- Brightness
bind("XF86MonBrightnessUp", exec("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true, description = "Brightness Up" })
bind("XF86MonBrightnessDown", exec("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true, description = "Brightness Down" })

-- Media
bind("XF86AudioNext", exec("playerctl next"), { locked = true, description = "Next Track" })
bind("XF86AudioPause", exec("playerctl play-pause"), { locked = true, description = "Pause" })
bind("XF86AudioPlay", exec("playerctl play-pause"), { locked = true, description = "Play" })
bind("XF86AudioPrev", exec("playerctl previous"), { locked = true, description = "Prev Track" })
