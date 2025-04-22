{ lib, config, ... }: {
  #imports = [ ./hexToRgb ];

  programs.rofi.theme = let
    # Use `mkLiteral` for string-like values that should show without
    # quotes, e.g.:
    # {
    #   foo = "abc"; =&gt; foo: "abc";
    #   bar = mkLiteral "abc"; =&gt; bar: abc;
    # };
    inherit (config.lib.formats.rasi) mkLiteral;
    colors = config.lib.stylix.colors.withHashtag;
    dark = colors.base00;
    light = colors.base07;
    border = colors.base0C;
    selected1 = colors.base0D;
    selected2 = colors.base0E;
    wallpaperPath = "${toString config.stylix.image}";
    hexToRgb = import ./hexToRgb.nix;
    dark-rgb = hexToRgb dark;
  in lib.mkForce {
    "configuration" = {
      modi = "drun,filebrowser,window,run";
      show-icons = true;
      display-drun = " ";
      display-run = " ";
      display-filebrowser = " ";
      display-window = " ";
      drun-display-format = "{name}";
      window-format = "{w}{t}";
      font = "JetBrainsMono Nerd Font 10";
      icon-theme = "Papirus";
    };

    "window" = {
      height = mkLiteral "480px"; # 600
      width = mkLiteral "720px"; # 900
      transparency = "real";
      fullscreen = false;
      enabled = true;
      cursor = "default";
      spacing = mkLiteral "0px";
      padding = mkLiteral "0px";
      border = mkLiteral "2px";
      border-radius = mkLiteral "32px"; # 40
      border-color = mkLiteral "${border}";
      background-color = mkLiteral ''
        rgba(${builtins.toString dark-rgb.r}, ${
          builtins.toString dark-rgb.g
        }, ${builtins.toString dark-rgb.b}, 0.4)
      '';
    };

    "mainbox" = {
      enabled = true;
      spacing = mkLiteral "0px";
      padding = mkLiteral "0px";
      orientation = mkLiteral "vertical";
      children = map mkLiteral [ "inputbar" "listbox" ];
      background-color = mkLiteral "transparent";
    };

    "inputbar" = {
      enabled = true;
      spacing = mkLiteral "0px";
      padding = mkLiteral "64px"; # 80
      children = map mkLiteral [ "entry" ];
      background-color = mkLiteral "transparent";
      background-image = mkLiteral ''url("${wallpaperPath}", width)'';
    };

    "entry" = {
      border-radius = mkLiteral "24px"; # 30
      enabled = true;
      spacing = mkLiteral "0px";
      padding = mkLiteral "16px"; # 20
      text-color = mkLiteral "${light}";
      background-color = mkLiteral "${dark}";
    };

    "listbox" = {
      padding = mkLiteral "24px"; # 30
      spacing = mkLiteral "0px";
      orientation = mkLiteral "horizontal";
      children = map mkLiteral [ "listview" "mode-switcher" ];
      background-color = mkLiteral "transparent";
    };

    "listview" = {
      padding = mkLiteral "8px"; # 10
      spacing = mkLiteral "8px"; # 10
      enabled = true;
      columns = 2;
      cycle = true;
      dynamic = true;
      scrollbar = false;
      layout = mkLiteral "vertical";
      reverse = false;
      fixed-height = true;
      fixed-columns = true;
      cursor = "default";
      background-color = mkLiteral "transparent";
      text-color = mkLiteral "${light}";
    };

    "mode-switcher" = {
      orientation = mkLiteral "vertical";
      width = mkLiteral "76px"; # 95
      enabled = true;
      padding = mkLiteral "12px";
      spacing = mkLiteral "10px"; # 10
      background-color = mkLiteral "transparent";
    };

    "button" = {
      cursor = mkLiteral "pointer";
      border-radius = mkLiteral "40px"; # 50
      background-color = mkLiteral "${light}";
      text-color = mkLiteral "${dark}";
    };

    "button selected" = {
      background-color = mkLiteral "${selected2}";
      text-color = mkLiteral "${light}";
    };

    "element" = {
      enabled = true;
      spacing = mkLiteral "16px"; # 20
      padding = mkLiteral "7px"; # 9
      border-radius = mkLiteral "20px"; # 25
      cursor = mkLiteral "pointer";
      background-color = mkLiteral "transparent";
      text-color = mkLiteral "${light}";
    };

    "element selected.normal" = {
      background-color = mkLiteral "${selected1}";
      text-color = "${light}";
    };

    "element-icon" = {
      size = mkLiteral "38px";
      cursor = mkLiteral "inherit";
      background-color = mkLiteral "transparent";
      text-color = mkLiteral "inherit";
    };

    "element-text" = {
      vertical-align = mkLiteral "0.5";
      horizontal-align = mkLiteral "0.0";
      cursor = mkLiteral "inherit";
      background-color = mkLiteral "transparent";
      text-color = mkLiteral "inherit";
    };
  };
}
