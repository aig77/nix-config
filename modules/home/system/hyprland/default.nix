{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  # darker gray, blue, magenta
  inherit (config.lib.stylix) colors;

  launcherCommand =
    if config.var.launcher == "rofi"
    then "rofi -show drun"
    else "";

  view-binds = import ./view-binds.nix {inherit pkgs config;};
in {
  imports = [
    ../hypridle
    ../hyprlock
    ../hyprpanel
    ../rofi
  ];

  config = lib.mkIf (config.var.desktop == "hyprland") {
    home.packages = [pkgs.hyprpolkitagent view-binds];

    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
      systemd.variables = ["--all"];
      plugins = with inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}; [
        hyprfocus
      ];

      settings = {
        exec-once = ["systemctl --user start hyprpolkitagent"];

        env = [
          "NIXOS_OZONE_WL,1"
          "MOZ_ENABLE_WAYLAND,1"
          "XDG_SESSION_TYPE,wayland"
          "XDG_SESSION_DESKTOP,Hyprland"
          "T_QPA_PLATFORM,wayland"
          "GDK_BACKEND,wayland"
          "ELECTRON_OZONE_PLATFORM_HINT,auto"
        ];

        monitor = [",preferred,auto,auto"];

        bindd = [
          "SUPER, slash, View Keybinds, exec, view-binds"

          # Shortcuts
          "SUPER, RETURN, Open Terminal, exec, ${config.var.terminal}"
          "SUPER, SPACE, Open Launcher, exec, ${launcherCommand}"
          "SUPER, C, Lock Screen, exec, ${config.var.lock}"

          # Screenshots
          ", PRINT, Screenshot Area, exec, screenshot-area"
          "SHIFT, PRINT, Screenshot Screen, exec, screenshot-screen"
          "CTRL, PRINT, Screenshot Window, exec, screenshot-window"

          # Hypr binds
          "SUPER, Q, Kill Active Window, killactive"
          "SUPER SHIFT, Q, Exit Hyprland, exit"
          "SUPER, T, Toggle Floating, togglefloating"
          "SUPER, P, Pseudo Tiling, pseudo"
          "SUPER, O, Toggle Split, togglesplit"
          "SUPER, F, Fullscreen (Internal), fullscreen, 0"
          "SUPER SHIFT, F, Fullscreen (Global), fullscreen, 1"

          # Vim-style Navigation
          "SUPER, H, Move Focus Left, movefocus, l"
          "SUPER, J, Move Focus Down, movefocus, d"
          "SUPER, K, Move Focus Up, movefocus, u"
          "SUPER, L, Move Focus Right, movefocus, r"

          # Vim-style Window Movement
          "SUPER SHIFT, H, Move Window Left, movewindow, l"
          "SUPER SHIFT, J, Move Window Down, movewindow, d"
          "SUPER SHIFT, K, Move Window Up, movewindow, u"
          "SUPER SHIFT, L, Move Window Right, movewindow, r"

          "SUPER, tab, Cycle Next Window, cyclenext"

          # Workspaces (example for 1 and 2, repeat for others)
          "SUPER, 1, Switch to Workspace 1, workspace, 1"
          "SUPER, 2, Switch to Workspace 2, workspace, 2"
          # ... and so on

          "SUPER SHIFT, 1, Move to Workspace 1, movetoworkspace, 1"
          "SUPER SHIFT, 2, Move to Workspace 2, movetoworkspace, 2"
          # ... and so on

          "SUPER, S, Toggle Special Workspace, togglespecialworkspace, magic"
          "SUPER SHIFT, S, Move to Special Workspace, movetoworkspace, special:magic"
          "SUPER, mouse_down, Next Workspace, workspace, e+1"
          "SUPER, mouse_up, Previous Workspace, workspace, e-1"
        ];

        # Mouse binds remain in bindm as they don't support bindd descriptions yet
        bindm = [
          "SUPER, mouse:272, movewindow"
          "SUPER, mouse:273, resizewindow"
        ];

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
          gaps_in = 8;
          gaps_out = 20;

          border_size = 2;

          "col.active_border" =
            lib.mkForce
            "rgb(${colors.base0D}) rgb(${colors.base0E}) rgb(${colors.base0D}) 45deg";

          "col.inactive_border" = lib.mkForce "rgb(${colors.base02})";

          layout = "dwindle";

          allow_tearing = false;
        };

        decoration = {
          rounding = 12;

          active_opacity = 1.0;
          inactive_opacity = 0.92;

          shadow = {
            range = 25;
            render_power = 3;
          };

          blur = {
            enabled = true;

            size = 10;
            passes = 3;

            noise = 0.01;
            contrast = 0.8;
            vibrancy = 0.2;

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
            # "easeOutQuint, 0.22, 1, 0.36, 1"
            # "easeInOutCubic, 0.65, 0, 0.35, 1"
            # "linear, 0, 0, 1, 1"

            "smoothOut, 0.36, 0, 0.66, -0.56"
            "smoothIn, 0.25, 1, 0.5, 1"
            "overshot, 0.05, 0.9, 0.1, 1.05"
            "softSnap, 0.4, 0, 0.2, 1"
            "fluent, 0.0, 0.0, 0.2, 1.0"
          ];

          animation = [
            # "windows, 1, 4, easeOutQuint, slide"
            # "windowsIn, 1, 4, easeOutQuint, popin 90%"
            # "windowsOut, 1, 4, easeInOutCubic, popin 90%"
            # "windowsMove, 1, 4, easeOutQuint, slide"
            # "border, 1, 5, easeInOutCubic"
            # "fade, 1, 3, easeInOutCubic"
            # "workspaces, 1, 3, easeOutQuint, slide"
            # "layers, 1, 4, easeOutQuint, slide"

            "windows, 1, 5, overshot, popin 80%"
            "windowsIn, 1, 5, overshot, popin 80%"
            "windowsOut, 1, 4, smoothOut, popin 90%"
            "windowsMove, 1, 3, softSnap"

            "layersIn, 1, 3, smoothIn, slide"
            "layersOut, 1, 2, softSnap, slide"

            "fade, 1, 4, smoothIn"
            "fadeIn, 1, 4, smoothIn"
            "fadeOut, 1, 4, smoothOut"
            "fadeSwitch, 1, 4, smoothIn"
            "fadeShadow, 1, 4, smoothIn"
            "fadeDim, 1, 4, smoothIn"
            "fadeDpms, 1, 4, smoothIn"

            "workspaces, 1, 5, overshot, slide"
            "specialWorkspace, 1, 5, overshot, slidevert"
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

        # Stopped working after upgrading to 26.05 12/12/2025
        layerrule = [
          # "blur, rofi"
          # "dimaround, rofi"
          # "ignorezero, rofi"
          # "blur, waybar"
          # "blur, wlogout"
        ];
      };
    };
  };
}
