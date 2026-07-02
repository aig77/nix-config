{config, ...}: let
  inherit (config.flake.meta.owner) username;
  hm = config.flake.modules.homeManager;
  inherit (config.flake.modules) nixos;
in {
  flake.modules.nixos.hyprland-hyprpanel = {config, ...}: {
    imports = [nixos.sddm nixos.hyprland];
    var.desktop = "hyprpanel";
    home-manager.users.${username}.imports = [
      hm.hyprland
      hm.hyprpanel-shell
      hm.screenshot
    ];
    sops.secrets.weatherapi-key = {};
    sops.templates."weatherapi.json" = {
      content = builtins.toJSON {
        weather_api_key = config.sops.placeholder."weatherapi-key";
      };
      mode = "0444";
      owner = config.users.users.${username}.name;
      inherit (config.users.users.${username}) group;
    };
  };
}
