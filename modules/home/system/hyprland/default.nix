{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  # darker gray, blue, magenta
  inherit (config.lib.stylix.colors) base02 base0D base0E;
in {
  imports = [
    ./keybinds.nix
    ./monitors.nix
    ./polkitagent.nix
    ../hyprlock
    ../hypridle
    # ../dunst
    ../hyprpanel
    ../rofi
    # ../wlogout
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.variables = ["--all"];
    plugins = with inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}; [
      hyprfocus
    ];

    settings = {
      exec-once = ["hypridle"];

      env = [
        "NIXOS_OZONE_WL,1"
        "MOZ_ENABLE_WAYLAND,1"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "T_QPA_PLATFORM,wayland"
        "GDK_BACKEND,wayland"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
      ];

      plugins.hyprfocus.enable = "yes";

      input = {
        kb_layout = "us";

        follow_mouse = 1;

        touchpad = {
          natural_scroll = true;
          clickfinger_behavior = true;
        };

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification
        force_no_accel = true;
        accel_profile = "flat";
      };

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" =
          lib.mkForce
          "rgb(${base0D}) rgb(${base0E}) rgb(${base0D}) 45deg";
        "col.inactive_border" = lib.mkForce "rgb(${base02})";

        layout = "dwindle";

        allow_tearing = false;
      };

      decoration = {
        rounding = 12;

        blur = {
          enabled = true;
          size = 8;
          passes = 4;
          new_optimizations = true;
          ignore_opacity = true;
        };
      };

      dwindle = {
        pseudotile = "yes";
        force_split = 2; # split right
        preserve_split = "yes";
      };

      misc = {
        force_default_wallpaper = 0; # Set to 0 to disable the anime mascot wallpapers
        disable_hyprland_logo = true;
        focus_on_activate = true;
      };

      animations = {
        enabled = true;
        bezier = [
          "easeOutQuint, 0.22, 1, 0.36, 1"
          "easeInOutCubic, 0.65, 0, 0.35, 1"
          "linear, 0, 0, 1, 1"
        ];
        animation = [
          "windows, 1, 4, easeOutQuint, slide"
          "windowsIn, 1, 4, easeOutQuint, popin 90%"
          "windowsOut, 1, 4, easeInOutCubic, popin 90%"
          "windowsMove, 1, 4, easeOutQuint, slide"
          "border, 1, 5, easeInOutCubic"
          "fade, 1, 3, easeInOutCubic"
          "workspaces, 1, 3, easeOutQuint, slide"
          "layers, 1, 4, easeOutQuint, slide"
        ];
      };

      windowrulev2 = [
        "float, class:^(org.pulseaudio.pavucontrol)$"
        "float, class:^(nm-connection-editor)$"
        "float, class:^(.blueman-manager-wrapped)$"
        "float, title:^(.*Bitwarden Password Manager.*)$"
        "float, title:Calculator"

        "opacity 0.8 0.8, class:^(discord)$"
        "opacity 0.8 0.8, class:^(obsidian)$"
        "opacity 0.8 0.8, class:^(spotify)$"
        "opacity 0.8 0.8, class:^(steam)$"
        "opacity 0.8 0.8, class:^(thunar)$"
        "opacity 0.8 0.8, class:^(org.pwmt.zathura)$"

        # Force games to be fullscreen
        "fullscreen, class:^(steam_app_.*)$"
        "fullscreen, class:^(gamescope)$"

        # idle inhibit while watching videos
        "idleinhibit focus, class:^(zen*)$, title:^(.*YouTube.*)$"
        "idleinhibit fullscreen, class:^(zen*)$"

        # xwaylandvideobridge
        "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
        "noanim,class:^(xwaylandvideobridge)$"
        "noinitialfocus,class:^(xwaylandvideobridge)$"
        "maxsize 1 1,class:^(xwaylandvideobridge)$"
        "noblur,class:^(xwaylandvideobridge)$"
      ];

      layerrule = [
        "blur, rofi"
        "dimaround, rofi"
        "ignorezero, rofi"
        "blur, waybar"
        "blur, wlogout"
      ];
    };
  };
}
