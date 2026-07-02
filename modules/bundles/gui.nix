{config, ...}: let
  hm = config.flake.modules.homeManager;
in {
  flake.modules.homeManager.gui = {var, ...}: {
    imports =
      [hm.${var.terminal}]
      ++ (with hm; [
        discord
        nixcord
        zen
      ]);
  };
}
