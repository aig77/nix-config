{config, ...}: let
  inherit (config.flake.meta.owner) username;
  hm = config.flake.modules.homeManager;
in {
  flake.modules.nixos.niri = _: {
    programs.niri.enable = true;
    home-manager.users.${username}.imports = [hm.niri];
  };

  flake.modules.homeManager.niri = {
    pkgs,
    var,
    ...
  }: {
    home = {
      packages = with pkgs; [
        playerctl
        brightnessctl
      ];

      sessionVariables = {
        TERMINAL = var.terminal;
        BROWSER = var.browser;
        FILE_MANAGER = var.fileManager;
      };
    };

    wayland.windowManager.niri = {
      enable = true;
      settings = {
        input.keyboard.xkb = {
          layout = "us";
        };

        binds = {
          "Mod+Return".spawn = [var.terminal];
          "Mod+Space".spawn-sh = "noctalia msg panel-toggle launcher";
          "Mod+Q".close-window = {};
          "Mod+H".focus-column-left = {};
          "Mod+L".focus-column-right = {};
          "Mod+Shift+H".move-column-left = {};
          "Mod+Shift+L".move-column-right = {};
          "Mod+Shift+V".move-window-to-workspace-down = {};
          "Mod+Shift+Q".quit = {};
        };
      };
    };
  };
}
