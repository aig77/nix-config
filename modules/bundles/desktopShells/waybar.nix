{config, ...}: {
  flake.modules.homeManager.waybarShell = {
    imports = let
      hm = config.flake.modules.homeManager;
    in [
      hm.waybar
      hm.swaync
      hm.fuzzel
      hm.hyprlock
      hm.hypridle
      hm.wallpaperManager
    ];
  };
}
