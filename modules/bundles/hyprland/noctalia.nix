{config, ...}: let
  inherit (config.flake.meta.owner) username;
  hm = config.flake.modules.homeManager;
  inherit (config.flake.modules) nixos;
in {
  flake.modules.nixos.hyprland-noctalia = {...}: {
    imports = [nixos.ly nixos.hyprland];
    var.desktop = "noctalia";

    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;

    home-manager.users.${username}.imports = [
      hm.hyprland
      hm.noctalia
      hm.screenshot
    ];
  };
}
