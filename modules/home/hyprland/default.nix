{ pkgs, inputs, ... }:

{

  imports = [
    ./animations.nix
    ./keybinds.nix
    ./monitors.nix
  ]; 

  home.packages = with pkgs; [
    hyprshot
    dconf
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    #package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    #portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;

    settings = {
      exec-once = [
        "swww-daemon"
        "swww img ~/Downloads/nix-wallpaper-stripes-logo.png"
        "waybar"
      ];

      input = {
        kb_layout = "us";

        follow_mouse = 1;

        touchpad = {
          natural_scroll = "no";
        };

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification
        force_no_accel = true;
        accel_profile = "flat"; 
      };

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;

        layout = "dwindle";

        allow_tearing = false;
      };

      decoration = {
        rounding = 12;

        blur = {
          enabled = true;
          size = 4;
          new_optimizations = true;
          ignore_opacity = true;
        };

        #drop_shadow = "yes";
        #shadow_ignore_window = true;
        #shadow_range = 4;
        #shadow_render_power = 3;
        #col.shadow = "rgba(1a1a1aee)";
      };

      dwindle = {
        pseudotile = "yes";
        force_split = 2; # split right
        preserve_split = "yes";
      };

      misc = {
        force_default_wallpaper = -1; # Set to 0 to disable the anime mascot wallpapers
      };
    };
  };

}

