{config, ...}: let
  inherit (config.flake.meta.owner) username;
  hm = config.flake.modules.homeManager;
in {
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

    home-manager.users.${username}.imports = [hm.hyprland];
  };

  flake.modules.homeManager.hyprland = {
    pkgs,
    var,
    ...
  }: {
    home = {
      packages = with pkgs; [
        hyprpolkitagent
        playerctl
        brightnessctl
      ];

      sessionVariables = {
        TERMINAL = var.terminal;
        BROWSER = var.browser;
        FILE_MANAGER = var.fileManager;
        LOCATION = var.location;
        SELECT_WALLPAPER = "wallpaper-picker";
        SCREENSHOT_AREA = "screenshot-area";
        SCREENSHOT_SCREEN = "screenshot-screen";
        SCREENSHOT_WINDOW = "screenshot-window";
        HYPR_GAME_WORKSPACE = 4;
      };
    };

    # Mirror session vars into systemd user session so GDM-launched Hyprland inherits them
    # home.sessionVariables only reaches ~/.profile (login shells), not systemd user services
    systemd.user.sessionVariables = {
      TERMINAL = var.terminal;
      BROWSER = var.browser;
      FILE_MANAGER = var.fileManager;
      LOCATION = var.location;
      SELECT_WALLPAPER = "wallpaper-picker";
      SCREENSHOT_AREA = "screenshot-area";
      SCREENSHOT_SCREEN = "screenshot-screen";
      SCREENSHOT_WINDOW = "screenshot-window";
      HYPR_GAME_WORKSPACE = 4;
    };

    stylix.targets.hyprland.enable = false;

    services.hyprpaper.settings.splash = false;
  };
}
