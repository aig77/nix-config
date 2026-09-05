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
    var,
    config,
    osConfig,
    ...
  }: let
    # Single source of truth for shell-dependent behavior. Add an entry here whenever
    # a new hyprland-<shell> bundle is added; the bundle itself only sets var.desktop.
    shellCommands =
      {
        waybar = {
          launcher = "fuzzel";
          lock = "hyprlock";
        };
        hyprpanel = {
          launcher = "fuzzel";
          lock = "hyprlock";
        };
        quickshell = {
          launcher = "qs ipc call launcher toggle";
          lock = "hyprlock";
        };
        caelestia = {
          launcher = "caelestia shell drawers toggle launcher";
          lock = "caelestia shell lock lock";
        };
        noctalia = {
          launcher = "noctalia msg panel-toggle launcher";
          lock = "noctalia msg session lock";
        };
      }.${
        var.desktop
      };
  in {
    home = {
      packages = with pkgs; [
        hyprpolkitagent
        playerctl
	brightnessctl
      ];

      sessionVariables = {
        TERMINAL = var.terminal;
        BROWSER = var.browser;
        LAUNCHER = shellCommands.launcher;
        LOCKSCREEN = shellCommands.lock;
        FILE_MANAGER = var.fileManager;
        LOCATION = var.location;
        SELECT_WALLPAPER = "wallpaper-picker";
        SCREENSHOT_AREA = "screenshot-area";
        SCREENSHOT_SCREEN = "screenshot-screen";
        SCREENSHOT_WINDOW = "screenshot-window";
        HYPR_GAME_WORKSPACE = 4;
        HYPR_SHELL = var.desktop;
      };
    };

    # Mirror session vars into systemd user session so GDM-launched Hyprland inherits them
    # home.sessionVariables only reaches ~/.profile (login shells), not systemd user services
    systemd.user.sessionVariables = {
      TERMINAL = var.terminal;
      BROWSER = var.browser;
      LAUNCHER = shellCommands.launcher;
      LOCKSCREEN = shellCommands.lock;
      FILE_MANAGER = var.fileManager;
      LOCATION = var.location;
      SELECT_WALLPAPER = "wallpaper-picker";
      SCREENSHOT_AREA = "screenshot-area";
      SCREENSHOT_SCREEN = "screenshot-screen";
      SCREENSHOT_WINDOW = "screenshot-window";
      HYPR_GAME_WORKSPACE = 4;
      HYPR_SHELL = var.desktop;
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
