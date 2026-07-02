-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

local shell = os.getenv("HYPR_SHELL") or "quickshell"

hl.on("hyprland.start", function()
  hl.exec_cmd("hyprpolkitagent")
  if shell ~= "caelestia" and shell ~= "noctalia" then
    hl.exec_cmd("hypridle")
  end
  hl.exec_cmd("playerctld")

  if shell == "quickshell" then
    hl.exec_cmd("quickshell")
  elseif shell == "waybar" then
    hl.exec_cmd("waybar")
  elseif shell == "hyprpanel" then
    hl.exec_cmd("hyprpanel")
  elseif shell == "caelestia" then
    hl.exec_cmd("caelestia-shell")
  elseif shell == "noctalia" then
    hl.exec_cmd("noctalia")
  end
end)
