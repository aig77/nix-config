_: {
  flake.modules.homeManager.base = {
    var,
    lib,
    pkgs,
    ...
  }: let
    launcherCommand =
      if var.launcher == "rofi"
      then "rofi -show drun"
      else if var.launcher == "quickshell"
      then "qs ipc call launcher toggle"
      else var.launcher;
  in {
    # Expose var.* as session variables so runtime configs (Hyprland lua, scripts, etc.)
    # can reference them without build-time substitution.
    home.sessionVariables =
      lib.mkDefault
      (
        {
          TERMINAL = var.terminal;
          BROWSER = var.browser;
        }
        // lib.optionalAttrs pkgs.stdenv.isLinux {
          LAUNCHER = launcherCommand;
          LOCKSCREEN = var.lock;
          FILE_MANAGER = var.fileManager;
          WALLPAPER_ENGINE = var.wallpaperEngine;
          WALLPAPER_PATH = var.wallpaperPath;
          LOCATION = var.location;

          # Screenshot scripts (static - not var options)
          SCREENSHOT_AREA = "screenshot-area";
          SCREENSHOT_SCREEN = "screenshot-screen";
          SCREENSHOT_WINDOW = "screenshot-window";

          # Wallpaper picker script (static - not a var option)
          SELECT_WALLPAPER = "wallpaper-picker";
        }
      );
  };
}
