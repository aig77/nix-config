{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.lib.stylix) colors;
in {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.${config.var.terminal}}/bin/${config.var.terminal}";
        width = 50;
        lines = 10;
        horizontal-pad = 32;
        vertical-pad = 16;
        inner-pad = 12;
        layer = "overlay";
        font = lib.mkForce "${config.stylix.fonts.monospace.name}:size=14";
        icons-enabled = true;
        launch-prefix = "";
        line-height = 25;
        filter-desktop = true;
        prompt = ''"󰍉 "'';
      };

      colors = {
        background = lib.mkForce "${colors.base00}99";
        #   text = "${colors.base05}ff"; # text
        #   match = "${colors.base08}ff"; # red/accent for matches
        #   selection = "${colors.base02}ff"; # surface0/selection bg
        #   selection-text = "${colors.base05}ff";
        #   selection-match = "${colors.base08}ff";
        #   border = "${colors.base0D}ff"; # blue accent
      };

      border = {
        width = 2;
        radius = 12;
      };
    };
  };
}
