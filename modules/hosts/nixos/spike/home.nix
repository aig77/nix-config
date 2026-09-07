{config, ...}: let
  inherit (config.flake.meta.owner) username;
  hm = config.flake.modules.homeManager;
in {
  configurations.nixos.spike.module = {pkgs, ...}: {
    home-manager.users.${username} = {
      imports = [hm.obs];
      home = {
        homeDirectory = "/home/${username}";
        stateVersion = "25.05";
        packages = with pkgs; [lmstudio];
        sessionVariables = {
          EDITOR = "nvim";
          WALLPAPERS = "$HOME/Pictures/Wallpapers";
          XDG_CONFIG_HOME = "$HOME/.config";
        };
      };
    };
  };
}
