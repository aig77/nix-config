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

      theme.font = {
        name = "JetBrainsMono Nerd Font";
        size = "14px";
      };

      theme.bar.floating = true;
      theme.bar.transparent = true;
      theme.bar.border_radius = "0.8em";
      theme.bar.outer_spacing = "0.8em";
      theme.bar.margin_top = "0.2em";
      theme.bar.margin_bottom = "0.2em";
      theme.bar.margin_sides = "0em";
      theme.bar.layer = "overlay";
      theme.bar.buttons.radius = "1em";
      theme.bar.opacity = 95;

      theme.bar.menus.menu.dashboard.profile.size = "10em";
      theme.bar.menus.menu.dashboard.profile.radius = "5em";

      bar.launcher.icon = "";
      bar.workspaces.show_icons = false;
      bar.workspaces.show_numbered = true;
      bar.workspaces.monitorSpecific = false;
      bar.workspaces.workspaces = 8;

      menus.dashboard.powermenu.avatar.image = config.var.profileImagePath;
      menus.dashboard.directories.enabled = false;
      menus.dashboard.shortcuts.left.shortcut1.icon = "󰖟";
      menus.dashboard.shortcuts.left.shortcut1.command = config.var.browser;
      menus.dashboard.shortcuts.left.shortcut1.tooltip = "Browser";
      menus.dashboard.stats.enable_gpu = true;
      menus.clock.weather.enabled = false;
    };
  };
}
