{
  config,
  inputs,
  lib,
  pkgs,
  sops,
  ...
}: {
  programs.hyprpanel = {
    enable = lib.mkIf (config.var.desktop == "hyprland") true;
    package = inputs.hyprpanel.packages.${pkgs.stdenv.hostPlatform.system}.default;

    settings = {
      bar.layouts =
        if (config.var.hostname != "faye")
        then {
          "0" = {
            "left" = [
              "dashboard"
              "workspaces"
              "windowtitle"
            ];
            "middle" = [
              "media"
            ];
            "right" = [
              "systray"
              "volume"
              "network"
              "bluetooth"
              "clock"
              "notifications"
            ];
          };
        }
        else {
          "0" = {
            "left" = [
              "dashboard"
              "workspaces"
              "windowtitle"
            ];
            "middle" = [
              "media"
            ];
            "right" = [
              "systray"
              "clock"
              "cava"
              "volume"
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
        clock = {
          format = "%H:%M";
          showIcon = false;
        };
        volume.label = false;
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
