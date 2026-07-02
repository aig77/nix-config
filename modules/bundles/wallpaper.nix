{config, ...}: {
  flake.modules.homeManager.wallpaperManager = let
    hm = config.flake.modules.homeManager;
  in {
    imports = [hm.waypaper hm.awww];
  };
}
