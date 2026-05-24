-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

local shell = os.getenv("HYPR_SHELL") or "quickshell"

hl.on("hyprland.start", function()
  hl.exec_cmd("hyprpolkitagent")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("playerctld")

  if shell == "quickshell" then
    hl.exec_cmd("quickshell")
  elseif shell == "waybar" then
    hl.exec_cmd("waybar")
  elseif shell == "hyprpanel" then
    hl.exec_cmd("hyprpanel")
  end
end)
