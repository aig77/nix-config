{pkgs, ...}: {
  stylix = {
    enable = true;
    polarity = "dark";

    # https://github.com/tinted-theming/base16-schemes
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono Nerd Font";
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

    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/orangci/walls-catppuccin-mocha/master/minimalist-black-hole.png";
      sha256 = "sha256-UetLf/3ustmNAXTSoNjqAJKug+ZeMnyf2DMTr+h+eU4=";
    };

    cursor = {
      name = "catppuccin-mocha-light-cursors";
      package = pkgs.catppuccin-cursors.mochaLight;
      size = 24;
    };

    opacity = {
      applications = 0.8;
      desktop = 0.8;
      terminal = 0.8;
      popups = 0.8;
    };
  };
}
