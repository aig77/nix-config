{pkgs, ...}: {
  stylix = {
    enable = true;
    polarity = "dark";

    # https://github.com/tinted-theming/base16-schemes
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/orangci/walls-catppuccin-mocha/master/minimalist-black-hole.png";
      sha256 = "sha256-UetLf/3ustmNAXTSoNjqAJKug+ZeMnyf2DMTr+h+eU4=";
    };

    cursor = {
      name = "catppuccin-mocha-light-cursors";
      package = pkgs.catppuccin-cursors.mochaLight;
      size = 24;
    };

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
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };

    opacity = {
      applications = 1.0;
      desktop = 1.0;
      terminal = 1.0;
      popups = 1.0;
    };
  };
}
