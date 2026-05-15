{config, ...}: let
  inherit (config.flake.meta.owner) username;
  hm = config.flake.modules.homeManager;
  inherit (config.flake.modules) nixos;
in {
  flake.modules.nixos.hyprland-hyprpanel = _: {
    imports = [nixos.hyprland];
    home-manager.users.${username}.imports = [
      hm.hyprland
      hm.hyprpanelShell
      hm.screenshot
      {wayland.windowManager.hyprland.settings.exec-once = ["hyprpanel"];}
    ];
  };
}
