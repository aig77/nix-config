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
    else config.var.launcher;

  view-binds = import ./view-binds.nix {inherit pkgs config;};
in {
  imports = [
    ../fuzzel
    ../hypridle
    ../hyprlock
    ../hyprpanel
    ../waybar/test
    ../wlogout
  ];

  home.packages = [pkgs.hyprpolkitagent view-binds];

  # remove splash from hyprpaper when using it
  services.hyprpaper.settings.splash = false;

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.variables = ["--all"];
    plugins = with inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}; [
      hyprfocus
      # hyprscrolling
    ];

    settings = {
      exec-once = [
        "systemctl --user start hyprpolkitagent"
        # "waybar"
      ];

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

      plugin = {
        hyprfocus = {
          mode = "slide";
          slide_height = 10;
        };

        # hyprscrolling = {
        #   column_width = 0.5;
        #   full_screen_on_one_column = true;
        # };
      };

      bindd = [
        "SUPER, slash, View Keybinds, exec, view-binds"

        # Shortcuts
        "SUPER, RETURN, Open Terminal, exec, ${config.var.terminal}"
        "SUPER, SPACE, Open Launcher, exec, ${launcherCommand}"
        "SUPER, C, Lock Screen, exec, ${config.var.lock}"
        "SUPER, P, Logout, exec, ${config.var.logout}"

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

        # Navigation
        "SUPER, H, Move Focus Left, movefocus, l"
        "SUPER, J, Move Focus Down, movefocus, d"
        "SUPER, K, Move Focus Up, movefocus, u"
        "SUPER, L, Move Focus Right, movefocus, r"
        "SUPER SHIFT, H, Move Window Left, movewindow, l"
        "SUPER SHIFT, J, Move Window Down, movewindow, d"
        "SUPER SHIFT, K, Move Window Up, movewindow, u"
        "SUPER SHIFT, L, Move Window Right, movewindow, r"

        "SUPER, tab, Cycle Next Window, cyclenext"

        # Workspaces
        "SUPER, 1, Switch to Workspace 1, workspace, 1"
        "SUPER, 2, Switch to Workspace 2, workspace, 2"
        "SUPER, 3, Switch to Workspace 3, workspace, 3"
        "SUPER, 4, Switch to Workspace 4, workspace, 4"
        "SUPER, 5, Switch to Workspace 5, workspace, 5"
        "SUPER, 6, Switch to Workspace 6, workspace, 6"
        "SUPER, 7, Switch to Workspace 7, workspace, 7"
        "SUPER, 8, Switch to Workspace 8, workspace, 8"
        "SUPER SHIFT, 1, Move to Workspace 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, Move to Workspace 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, Move to Workspace 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, Move to Workspace 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, Move to Workspace 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, Move to Workspace 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, Move to Workspace 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, Move to Workspace 8, movetoworkspace, 8"

        # Other
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

          size = 8;
          passes = 4;

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
          "smoothOut, 0.36, 0, 0.66, -0.56"
          "smoothIn, 0.25, 1, 0.5, 1"
          "overshot, 0.05, 0.9, 0.1, 1.05"
          "softSnap, 0.4, 0, 0.2, 1"
          "fluent, 0.0, 0.0, 0.2, 1.0"
        ];

        animation = [
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

      windowrule = [
        # Floating windows
        "match:class ^(org.pulseaudio.pavucontrol)$, float on"
        "match:class ^(nm-connection-editor)$, float on"
        "match:class ^(.blueman-manager-wrapped)$, float on"
        "match:title ^(.*Bitwarden Password Manager.*)$, float on"
        "match:title Calculator, float on"

        # Game settings
        "match:class ^(steam_app_.*)$, fullscreen on"
        "match:class ^(steam_app_.*)$, workspace 8"
        "match:class ^(gamescope)$, fullscreen on"
        "match:class ^(gamescope)$, workspace 8"

        # idle inhibit while watching videos
        "match:class ^(zen*)$, match:title ^(.*YouTube.*)$, idle_inhibit focus"
        "match:class ^(zen*)$, idle_inhibit fullscreen"

        # Hide during screenshare
        "match:title ^(.*Bitwarden Password Manager.*)$, no_screen_share on"
      ];

      # Stopped working after upgrading to 26.05 12/12/2025
      layerrule = [
        "blur on, match:namespace bar-0" # hyprpanel
        "blur on, match:namespace launcher"
        "ignore_alpha 0.5, match:namespace launcher"
        "blur on, match:namespace rofi"
        "ignore_alpha 0.5, match:namespace rofi"
      ];
    };
  };
}
