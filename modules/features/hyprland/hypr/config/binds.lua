local shell = os.getenv("HYPR_SHELL") or "quickshell"
local bind = hl.bind
local exec = hl.dsp.exec_cmd
local win = hl.dsp.window
local focus = hl.dsp.focus
local ws = hl.dsp.workspace
local layout = hl.dsp.layout

local function m(k)
  return "SUPER+" .. k
end
local function ms(k)
  return "SUPER+SHIFT+" .. k
end
local function c(k)
  return "CTRL+" .. k
end
local function a(k)
  return "ALT+" .. k
end
local function s(k)
  return "SHIFT+" .. k
end
local function ca(k)
  return "CTRL+ALT+" .. k
end
local function d(s, flags)
  local t = flags or {}
  t.description = s
  return t
end

-- Apps
bind(m("RETURN"), exec("$TERMINAL"), d("Open Terminal"))
bind(m("SPACE"), exec("$LAUNCHER"), d("Open Launcher"))
bind(m("W"), exec("$SELECT_WALLPAPER"), d("Select Wallpaper"))
bind(ca("L"), exec("$LOCKSCREEN"), d("Lock Screen"))

-- Screenshots
bind("PRINT", exec("$SCREENSHOT_AREA"), d("Screenshot Area"))
bind(s("PRINT"), exec("$SCREENSHOT_SCREEN"), d("Screenshot Screen"))
bind(c("PRINT"), exec("$SCREENSHOT_WINDOW"), d("Screenshot Window"))

-- Window management
bind(m("Q"), win.close(), d("Close Window"))
bind(ms("Q"), hl.dsp.exit(), d("Exit Hyprland"))
bind(m("T"), win.float({ action = "toggle" }), d("Toggle Floating"))
bind(m("F"), win.fullscreen({ mode = "fullscreen", action = "toggle" }), d("Fullscreen"))
bind(m("M"), win.fullscreen({ mode = "maximized", action = "toggle" }), d("Maximize"))
bind(m("tab"), win.cycle_next(), d("Cycle Next"))
bind(ms("tab"), win.cycle_next({ next = "prev" }), d("Cycle Prev"))

-- Focus
bind(m("H"), focus({ direction = "left" }), d("Focus Left"))
bind(m("J"), focus({ direction = "down" }), d("Focus Down"))
bind(m("K"), focus({ direction = "up" }), d("Focus Up"))
bind(m("L"), focus({ direction = "right" }), d("Focus Right"))

-- Move windows
bind(ms("H"), win.swap({ direction = "left" }), d("Move Window Left"))
bind(ms("J"), win.swap({ direction = "down" }), d("Move Window Down"))
bind(ms("K"), win.swap({ direction = "up" }), d("Move Window Up"))
bind(ms("L"), win.swap({ direction = "right" }), d("Move Window Right"))

-- Scrolling layout
if LAYOUT == "scrolling" then
  bind(m("bracketright"), layout("colresize +conf"), d("Expand Column"))
  bind(m("bracketleft"), layout("colresize -conf"), d("Shrink Column"))
  bind(m("comma"), layout("consume_or_expel next"), d("Consume or Expel Into Column"))
end

-- Workspaces
for i = 1, 10 do
  local key = i % 10
  bind(m(key), focus({ workspace = i }), d("Switch to Workspace " .. i))
  bind(ms(key), win.move({ workspace = i }), d("Move to Workspace " .. i))
end

-- Shell-specific
if shell == "quickshell" then
  bind(a("tab"), exec("qs ipc call overview toggle"), d("Workspace Overview"))
  bind(m("escape"), exec("qs ipc call controlcenter toggle"), d("Control Center"))
end

-- Scratchpad
bind(m("S"), ws.toggle_special("magic"), d("Toggle Scratchpad"))
bind(ms("S"), win.move({ workspace = "special:magic" }), d("Move to Scratchpad"))

-- Resize
bind(m("right"), win.resize({ x = 10, y = 0 }), d("Resize Right", { repeating = true }))
bind(m("left"), win.resize({ x = -10, y = 0 }), d("Resize Left", { repeating = true }))
bind(m("up"), win.resize({ x = 0, y = -10 }), d("Resize Up", { repeating = true }))
bind(m("down"), win.resize({ x = 0, y = 10 }), d("Resize Down", { repeating = true }))

-- Volume
bind("XF86AudioRaiseVolume", exec("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), d("Volume Up", { locked = true, repeating = true }))
bind("XF86AudioLowerVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), d("Volume Down", { locked = true, repeating = true }))
bind("XF86AudioMute", exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), d("Mute Audio", { locked = true, repeating = true }))
bind("XF86AudioMicMute", exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), d("Mute Microphone", { locked = true, repeating = true }))

-- Brightness
bind("XF86MonBrightnessUp", exec("brightnessctl -e4 -n2 set 5%+"), d("Brightness Up", { locked = true, repeating = true }))
bind("XF86MonBrightnessDown", exec("brightnessctl -e4 -n2 set 5%-"), d("Brightness Down", { locked = true, repeating = true }))

-- Media
bind("XF86AudioNext", exec("playerctl next"), d("Next Track", { locked = true }))
bind("XF86AudioPause", exec("playerctl play-pause"), d("Pause", { locked = true }))
bind("XF86AudioPlay", exec("playerctl play-pause"), d("Play", { locked = true }))
bind("XF86AudioPrev", exec("playerctl previous"), d("Prev Track", { locked = true }))
