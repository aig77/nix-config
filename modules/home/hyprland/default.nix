{ pkgs, lib, config, inputs,... }:
  let
    scheme = config.lib.stylix.colors;
  in {

  imports = [
    #./animations.nix
    ./keybinds.nix
    ./monitors.nix
    ../hyprlock
    ../hypridle
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
        "hypridle"
        "waybar"
      ];

      input = {
        kb_layout = "us";

        follow_mouse = 1;

        touchpad = {
          natural_scroll = "no";
        };

        sensitivity = -0.8; # -1.0 - 1.0, 0 means no modification
        force_no_accel = true;
        accel_profile = "flat"; 
      };

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = 
        lib.mkForce "rgb(${scheme.base05}) rgb(${scheme.base0D}) rgb(${scheme.base0C}) 45deg";
        "col.inactive_border" = lib.mkForce "rgb(${scheme.base03})";

        layout = "dwindle";

        allow_tearing = false;
      };

      decoration = {
        rounding = 12;

        blur = {
          enabled = true;
          size = 4;
          passes = 4;
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
        force_default_wallpaper = 0; # Set to 0 to disable the anime mascot wallpapers
      };

      animations = {
        enabled = true;
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "linear, 1, 1, 1, 1"
        ];

        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, linear"
          #"borderangle, 1, 1, 30, linear, loop"
          #"fade, 1, 10, default"
          "workspaces, 1, 5, wind"
          "layers, 1, 9, wind, slide top"
        ];
      };
      
      windowrulev2 = [
        # replaces nomaximizerequest, class:.* # You'll probably like this.
        #"windowrulev2 = suppressevent maximize, class:.*"
        #"windowrulev2 = forceinput, class:.*"
        "float, class:^(org.pulseaudio.pavucontrol)$"
        "float, class:^(nm-connection-editor)$"
        "float, class:^(.blueman-manager-wrapped)$"
      ];
      
      layerrule = [
        "blur, waybar"
        "blur, rofi"
        "dimaround, rofi"
        "ignorezero, rofi"
        "blur, wlogout"
      ];



    };
  };
}

