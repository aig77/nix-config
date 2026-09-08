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
          "Mod+Enter".action.spawn = "${var.terminal}";
          "Mod+Space".action.spawn = "noctalia msg panel-toggle launcher";
          "Mod+Q".action.close-window = {};
          "Mod+H".action.focus-column-left = {};
          "Mod+L".action.focus-column-right = {};
          "Mod+Shift+H".action.move-column-left = {};
          "Mod+Shift+L".action.move-column-right = {};
          "Mod+Shift+V".action.move-window-to-workspace-next = {};
          "Mod+Shift+Q".action.quit = {};
        };
      };
    };
  };
}
