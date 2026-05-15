{config, ...}: {
  flake.modules.homeManager.quickshellShell = {
    imports = let
      hm = config.flake.modules.homeManager;
    in [
      hm.quickshell
      hm.fuzzel
      hm.hyprlock
      hm.hypridle
      hm.wallpaperManager
    ];
  };
}
