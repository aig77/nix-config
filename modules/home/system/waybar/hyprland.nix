{
  imports = [./config.nix];

  programs.waybar.settings.mainbar = {
    "group/navigation" = {
      orientation = "horizontal";
      modules = ["hyprland/workspaces" "hyprland/window"];
    };

    "hyprland/workspaces" = {
      persistent-workspaces = {
        eDP-1 = [1 2 3 4 5 6 7 8];
      };
      on-click = "activate";
      sort-by-number = true;
      format = "{icon}";
      format-icons = {
        "1" = "";
        "2" = "";
        "3" = "";
        "4" = "";
        "5" = "";
        "6" = "";
        "7" = "";
        "8" = "";
      };
    };

    "hyprland/window" = {
      format = " {title}";
      max-length = 50;
      separate-outputs = true;
    };
  };
}
