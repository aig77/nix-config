{config, ...}: let
  host = config.var.hostname;
  m1 = "desc: ${config.var.monitors.main}";
  m2 = "desc: ${config.var.monitors.secondary}";
in {
  wayland.windowManager.hyprland =
    if (host == "spike")
    then {
      settings = {
        monitor = [
          "${m1}, highres@highrr, 0x0, 1, bitdepth, 10"
          "${m2}, highres@highrr, 2560x0, 1, bitdepth, 10"
        ];

        workspace = [
          "1, monitor:${m1}, default:true"
          "2, monitor:${m1}"
          "3, monitor:${m1}"
          "4, monitor:${m1}"

          "5, monitor:${m2}, default:true"
          "6, monitor:${m2}"
          "7, monitor:${m2}"
          "8, monitor:${m2}"
        ];
      };
    }
    else {
      settings = {monitor = [",preferred,auto,auto"];};
    };
}
