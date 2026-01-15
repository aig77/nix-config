{
  config,
  pkgs,
  ...
}: let
  inherit (config.lib.stylix) colors;
in
  pkgs.writeShellScriptBin "view-binds" ''
    BINDS=$(hyprctl binds -j | ${pkgs.jq}/bin/jq -r '.[] |
      select(.description | length > 0) |
      ((if (.modmask >= 64) then "󰘳 + " else "" end) +
       (if (.modmask % 64 >= 8) then "󰘵 + " else "" end) +
       (if (.modmask % 8 >= 4) then "󰘴 + " else "" end) +
       (if (.modmask % 4 >= 1) then "󰘶 + " else "" end) +
       "\(.key)  ➜  \(.description)")')

    LINE_COUNT=$(echo "$BINDS" | wc -l)

    echo "$BINDS" | ${pkgs.fuzzel}/bin/fuzzel --dmenu \
        --width 35 \
        --lines "$LINE_COUNT" \
        --font "${config.stylix.fonts.monospace.name}:size=10" \
        --anchor right \
        --line-height 20 \
        --x-margin 40 \
        --y-margin 40 \
        --border-width 2 \
        --border-radius 12 \
        --background-color ${colors.base00}ff \
        --text-color ${colors.base05}ff \
        --selection-color ${colors.base02}ff \
        --selection-text-color ${colors.base0D}ff \
        --border-color ${colors.base0D}ff \
        --input-color ${colors.base01}ff \
        --hide-prompt \
        --placeholder "Keybinds" \
        --
  ''
