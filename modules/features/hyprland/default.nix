_: {
  flake.modules.nixos.hyprland = {
    inputs,
    pkgs,
    ...
  }: let
    inherit (pkgs.stdenv.hostPlatform) system;
  in {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${system}.hyprland;
      portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
    };
  };

  flake.modules.homeManager.hyprland = {
    pkgs,
    lib,
    var,
    config,
    osConfig,
    ...
  }: let
    launcherCommand =
      if var.launcher == "rofi"
      then "rofi -show drun"
      else if var.launcher == "quickshell"
      then "qs ipc call launcher toggle"
      else var.launcher;
  in {
    home = {
      packages = with pkgs; [
        hyprpolkitagent
        playerctl
      ];

      sessionVariables = {
        TERMINAL = var.terminal;
        BROWSER = var.browser;
        LAUNCHER = launcherCommand;
        LOCKSCREEN = var.lock;
        FILE_MANAGER = var.fileManager;
        WALLPAPER_ENGINE = var.wallpaperEngine;
        WALLPAPER_PATH = var.wallpaperPath;
        LOCATION = var.location;
        SELECT_WALLPAPER = "wallpaper-picker";
        SCREENSHOT_AREA = "screenshot-area";
        SCREENSHOT_SCREEN = "screenshot-screen";
        SCREENSHOT_WINDOW = "screenshot-window";
        HYPR_GAME_WORKSPACE = 4;
        HYPR_SHELL = lib.mkDefault ""; # set when creating desktop shell bundle
      };
    };

    # Mirror session vars into systemd user session so GDM-launched Hyprland inherits them
    # home.sessionVariables only reaches ~/.profile (login shells), not systemd user services
    systemd.user.sessionVariables = {
      TERMINAL = var.terminal;
      BROWSER = var.browser;
      LAUNCHER = launcherCommand;
      LOCKSCREEN = var.lock;
      FILE_MANAGER = var.fileManager;
      WALLPAPER_ENGINE = var.wallpaperEngine;
      WALLPAPER_PATH = var.wallpaperPath;
      LOCATION = var.location;
      SELECT_WALLPAPER = "wallpaper-picker";
      SCREENSHOT_AREA = "screenshot-area";
      SCREENSHOT_SCREEN = "screenshot-screen";
      SCREENSHOT_WINDOW = "screenshot-window";
      HYPR_GAME_WORKSPACE = 4;
      HYPR_SHELL = lib.mkDefault ""; # set when creating desktop shell bundle
    };

    # Symlink both to prevent conflict with hypridle config
    # hypridle is supposed to go into ~/.config/hypr as well creating a conflict if you symlink all of hypr
    xdg.configFile = {
      "hypr/hyprland.lua".source =
        config.lib.file.mkOutOfStoreSymlink "${osConfig.var.repoPath}/modules/features/hyprland/hypr/hyprland.lua";

      "hypr/config".source =
        config.lib.file.mkOutOfStoreSymlink "${osConfig.var.repoPath}/modules/features/hyprland/hypr/config";
    };

    stylix.targets.hyprland.enable = false;

    services.hyprpaper.settings.splash = false;
  };
}
