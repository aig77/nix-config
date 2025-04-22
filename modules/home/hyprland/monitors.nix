{ config, ... }:
{
  #wayland.windowManager.hyprland = {
  #  settings = { monitor = [ ",preferred,auto,auto" ]; };
  #};
  
  wayland.windowManager.hyprland = if (config.var.configName == "desktop") then {
    settings = {
      monitor = [
        "DP-2, 2560x1440@300, 0x0, 1, bitdepth, 10"
        "DP-1, 2560x1440@144, 2560x0, 1, bitdepth, 10"
      ];

      workspace = [
        "1, monitor:DP-2"
        "2, monitor:DP-2"
        "3, monitor:DP-2"
        "4, monitor:DP-2"
        
        "5, monitor:DP-1"
        "6, monitor:DP-1"
        "7, monitor:DP-1"
        "8, monitor:DP-1"
      ];
    };
  } else {
    settings = { monitor = [ ",preferred,auto,auto" ]; };
  };
}
