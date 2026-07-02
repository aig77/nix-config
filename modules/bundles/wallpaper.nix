{config, ...}: {
  flake.modules.homeManager.wallpaperManager = {
    lib,
    var,
    ...
  }: let
    hm = config.flake.modules.homeManager;
  in {
    imports =
      lib.optionals (var.wallpaperEngine == "awww") [hm.waypaper hm.awww]
      ++ lib.optionals (var.wallpaperEngine == "wallpaperengine") [hm.wallpaperengine];
  };
}
