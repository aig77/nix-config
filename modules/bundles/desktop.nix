{config, ...}: let
  inherit (config.flake.meta.owner) username;
  hm = config.flake.modules.homeManager;
  inherit (config.flake.modules) nixos;
in {
  flake.modules.nixos.desktop = _: {
    imports = with nixos; [audio bluetooth boot theme thunar];
    home-manager.users.${username}.imports = with hm; [eyecandyNixos gui shell];
  };
}
