{config, ...}: {
  flake.modules.homeManager.waybar-shell = {
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
