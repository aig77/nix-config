{config, ...}: let
  inherit (config.flake.meta.owner) username;
  hm = config.flake.modules.homeManager;
  inherit (config.flake.modules) nixos;
in {
  flake.modules.nixos.hyprland-custom = _: {
    imports = [nixos.sddm nixos.hyprland];
    home-manager.users.${username}.imports = [
      hm.hyprland
      hm.waybar-shell
      hm.screenshot
      {home.sessionVariables.HYPR_SHELL = "waybar";}
    ];
  };
}
