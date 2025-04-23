{ config, ... }: 
let 
  m1 = "DP-2";
  m2 = "DP-3";
in 
{
  #wayland.windowManager.hyprland = {
  #  settings = { monitor = [ ",preferred,auto,auto" ]; };
  #};

  wayland.windowManager.hyprland =
    if (config.var.configName == "desktop") then {
      settings = {
        monitor = [
          "${m1}, 2560x1440@300, 0x0, 1, bitdepth, 10"
          "${m2}, 2560x1440@144, 2560x0, 1, bitdepth, 10"
        ];

        workspace = [
          "1, monitor:${m1}"
          "2, monitor:${m1}"
          "3, monitor:${m1}"
          "4, monitor:${m1}"

          "5, monitor:${m2}"
          "6, monitor:${m2}"
          "7, monitor:${m2}"
          "8, monitor:${m2}"
        ];
      };
    } else {
      settings = { monitor = [ ",preferred,auto,auto" ]; };
    };
}
