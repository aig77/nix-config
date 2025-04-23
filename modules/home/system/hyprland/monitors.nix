{ config, ... }: 
let 
  m1 = "desc: ASUSTek COMPUTER INC XG27AQMR SALMTF054549";
  m2 = "desc: LG Electronics LG ULTRAGEAR 107NTZN78013";
in 
{
  #wayland.windowManager.hyprland = {
  #  settings = { monitor = [ ",preferred,auto,auto" ]; };
  #};

  wayland.windowManager.hyprland =
    if (config.var.configName == "desktop") then {
      settings = {
        monitor = [
          "${m1}, highres@highrr, 0x0, 1, bitdepth, 10"
          "${m2}, highres@highrr, 2560x0, 1, bitdepth, 10"
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
