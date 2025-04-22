{ pkgs, lib, config, inputs, ... }:
let
  colors = config.lib.stylix.colors;
  active-border-color = {
    one = colors.base0C;
    two = colors.base0D;
    three = colors.base05;
  };
  inactive-border-color = colors.base03;
in {
  imports =
    [ ./keybinds.nix ./monitors.nix ./polkitagent.nix ../hyprlock ../hypridle ];

  home.packages = with pkgs; [
    qt5.qtwayland
    qt6.qtwayland
    libsForQt5.qt5ct
    libsForQt5.xwaylandvideobridge
    qt6ct
    imv
    wf-recorder
    wlr-randr
    wl-clipboard
    dconf
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    systemd.variables = [ "--all" ];
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    settings = {
      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "MOZ_ENABLE_WAYLAND,1"
        "NIXOS_OZONE_WL,1"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "T_QPA_PLATFORM,wayland"
        "GDK_BACKEND,wayland"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
      ];

      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "hypridle"
        "waybar"
        "xwaylandvideobridge"
      ];

      input = {
        kb_layout = "us";

        follow_mouse = 1;

        touchpad = {
          natural_scroll = true;
          clickfinger_behavior = true;
        };

        sensitivity = -0.5; # -1.0 - 1.0, 0 means no modification
        force_no_accel = true;
        accel_profile = "flat";
      };

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = lib.mkForce
          "rgb(${active-border-color.one}) rgb(${active-border-color.two}) rgb(${active-border-color.three}) 45deg";
        "col.inactive_border" = lib.mkForce "rgb(${inactive-border-color})";

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
        "float, title:^(.*Bitwarden Password Manager.*)$"

        # xwaylandvideobridge
        "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
        "noanim,class:^(xwaylandvideobridge)$"
        "noinitialfocus,class:^(xwaylandvideobridge)$"
        "maxsize 1 1,class:^(xwaylandvideobridge)$"
        "noblur,class:^(xwaylandvideobridge)$"
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

  xdg = {
    autostart.enable = true;
    portal = {
      enable = true;
      config = { common.default = "*"; };
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
