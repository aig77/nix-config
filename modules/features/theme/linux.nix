{inputs, ...}: {
  flake.modules.homeManager.theme = {config, ...}: let
    colors = config.lib.stylix.colors.withHashtag;
    font = config.stylix.fonts.monospace.name;
  in {
    # Base16 palette written to cache so runtime configs (Hyprland lua, Quickshell)
    # can read colors without needing build-time substitution.
    home.file.".cache/stylix/colors.json".text = builtins.toJSON {
      inherit
        (colors)
        base00
        base01
        base02
        base03
        base04
        base05
        base06
        base07
        base08
        base09
        base0A
        base0B
        base0C
        base0D
        base0E
        base0F
        ;
      inherit font;
    };
  };

  flake.modules.nixos.theme = {
    pkgs,
    config,
    ...
  }: {
    # Scoped to desktop only to avoid breaking server hosts that lack stylix options
    imports = [inputs.stylix.nixosModules.stylix];

    stylix = {
      enable = true;
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };
        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };

      cursor = {
        # name = "catppuccin-mocha-light-cursors";
        # package = pkgs.catppuccin-cursors.mochaLight;
        name = "catppuccin-mocha-dark-cursors";
        package = pkgs.catppuccin-cursors.mochaDark;
        size = 24;
      };

      icons = {
        dark = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };

    # Stylix installs the icon theme but doesn't expose it at a stable system path.
    # Adding it explicitly ensures icons are available at /run/current-system/sw/share/icons.
    environment.systemPackages = [config.stylix.icons.package];
  };
}
