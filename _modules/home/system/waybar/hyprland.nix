{
  imports = [./config.nix];

  programs.waybar.settings.mainBar = {
    layer = "top";

    modules-left = ["group/hyprlandNav"];

    modules-center = ["cava"];

    modules-right = [
      "clock"
      "wireplumber"
      "custom/exit"
    ];
  };
}
