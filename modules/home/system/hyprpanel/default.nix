{
  inputs,
  pkgs,
  config,
  ...
}: {
  wayland.windowManager.hyprland.settings.exec-once = ["hyprpanel"];

  programs.hyprpanel = {
    enable = true;
    package = inputs.hyprpanel.packages.${pkgs.system}.default;

    settings = {
      bar.layouts = {
        "*" = {
          "left" = [
            "dashboard"
            "windowtitle"
          ];
          "middle" = [
            "workspaces"
          ];
          "right" = [
            "systray"
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
          layer = "overlay";
          buttons.radius = "1em";
          opacity = 95;
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
          show_numbered = true;
          monitorSpecific = false;
          workspaces = 8;
        };
      };

      menus = {
        dashboard = {
          powermenu.avatar.image = config.var.profileImagePath;
          directories.enabled = false;
          shortcuts.left.shortcut1 = {
            icon = "󰖟";
            command = config.var.browser;
            tooltip = "Browser";
          };
          stats.enable_gpu = true;
          clock.weather.enabled = false;
        };
      };
    };
  };
}
