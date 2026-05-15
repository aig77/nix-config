{config, ...}: let
  hm = config.flake.modules.homeManager;
in {
  flake.modules.homeManager.gui = {
    imports = with hm; [
      zen
      helium
      ghostty
      alacritty
      discord
      spotify
      obs
      obsidian
      zathura
    ];
  };
}
