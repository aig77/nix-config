{config, ...}: {
  flake.modules.homeManager.hyprpanel-shell = {
    imports = let
      hm = config.flake.modules.homeManager;
    in [
      hm.hyprpanel
      hm.hyprlock
      hm.hypridle
      hm.fuzzel
    ];
  };
}
