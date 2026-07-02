{config, ...}: {
  flake.modules.homeManager.quickshell-shell = {
    imports = let
      hm = config.flake.modules.homeManager;
    in [
      hm.quickshell
      hm.hyprlock
      hm.hypridle
      hm.wlsunset
      hm.wallpaperManager
      hm.clipboard
    ];
  };
}
