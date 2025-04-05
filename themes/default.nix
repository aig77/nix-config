{ pkgs, ... }: {
  
  home.packages = [
    pkgs.papirus-icon-theme
  ];

  stylix = {
    enable = true;
    image = ./tokyo-night-cat.jpeg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    
    targets.waybar.enable = false; 
    targets.rofi.enable = false;

    cursor = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 22; 
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

      sizes = {
        applications = 12;
        desktop = 10;
        terminal = 12;
        popups = 10;
      };
    };

    opacity = {
      applications = 0.9;
      desktop = 0.9;
      terminal = 0.9;
      popups = 0.9;
    };

    polarity = "dark";
  };
}
