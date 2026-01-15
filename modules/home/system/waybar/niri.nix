{
  imports = [./config.nix];

  programs.waybar.settings.mainBar = {
    "group/navigation" = {
      orientation = "horizontal";
      modules = ["niri/workspaces" "niri/window"];
    };

    "niri/workspaces" = {
      persistent-workspaces = {
        eDP-1 = [1 2 3 4];
      };
      on-click = "activate";
      sort-by-number = true;
      format = "{icon}";
      format-icons = {
        "1" = "";
        "2" = "";
        "3" = "";
        "4" = "";
      };
    };

    "niri/window" = {
      format = " {title}";
      max-length = 50;
      separate-outputs = true;
    };
  };
}
