{
  inputs,
  pkgs,
  config,
  sops,
  ...
}: {
  programs.hyprpanel = {
    enable = true;
    package = inputs.hyprpanel.packages.${pkgs.stdenv.hostPlatform.system}.default;

    settings = {
      bar.layouts = {
        "0" = {
          "left" = [
            "dashboard"
            "workspaces"
            "windowtitle"
          ];
          "middle" = [
            "systray"
          ];
          "right" = [
            "volume"
            "clock"
            "notifications"
          ];
        };
      };

      theme = {
        font = {
          name = "JetBrainsMono Nerd Font";
          size = "14px";
        };
        bar = {
          floating = true;
          transparent = true;
          border_radius = "0.8em";
          outer_spacing = "0.8em";
          margin_top = "0.2em";
          margin_bottom = "0.2em";
          margin_sides = "0em";
          layer = "top";
          opacity = 95;
          buttons.radius = "1em";
        };
        menus.menu.dashboard.profile = {
          size = "10em";
          radius = "5em";
        };
      };

      bar = {
        launcher.icon = "";
        workspaces = {
          show_icons = false;
          show_numbered = false;
          monitorSpecific = false;
          workspaces = 8;
        };
      };

      menus = {
        dashboard = {
          directories.enabled = false;
          shortcuts.left.shortcut1 = {
            icon = "󰖟";
            command = config.var.browser;
            tooltip = "Browser";
          };
        };
        clock = {
          military = true;
          weather = {
            enabled = true;
            inherit (config.var) location;
            key = sops.templates."weatherapi.json".path;
            unit = "metric";
          };
        };
      };
    };
  };

  home.file.".face.icon".source = ../../../../hosts/nixos/${config.var.hostname}/icon.jpg;

  wayland.windowManager.hyprland.settings.exec-once = ["hyprpanel"];
}
