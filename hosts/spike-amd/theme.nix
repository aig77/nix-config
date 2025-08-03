{pkgs, ...}: {
  stylix = {
    enable = true;
    polarity = "dark";

    # https://github.com/tinted-theming/base16-schemes
    base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark.yaml";

    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/Narmis-E/onedark-wallpapers/main/misc/od_neon_warm.png";
      sha256 = "sha256-nVyujlMFdeDkqYNFp+2I1BUei9/pf+N9IBGezhZ2VWU=";
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

    sizes = {
      applications = 12;
      desktop = 10;
      terminal = 12;
      popups = 10;
    };

    opacity = {
      applications = 1.0;
      desktop = 1.0;
      terminal = 1.0;
      popups = 1.0;
    };

    cursor = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 22;
    };
  };
}
