{config, ...}: let
  colors = config.lib.stylix.colors.withHashtag;
in {
  programs.cava = {
    enable = true;

    settings = {
      color = {
        gradient = 1;
        gradient_count = 8;

        # Catppuccin Mocha color spectrum (teal → blue → mauve → flamingo → red)
        gradient_color_1 = "'${colors.base0C}'"; # teal
        gradient_color_2 = "'${colors.base0C}'"; # teal
        gradient_color_3 = "'${colors.base0D}'"; # blue
        gradient_color_4 = "'${colors.base0D}'"; # blue
        gradient_color_5 = "'${colors.base0E}'"; # mauve
        gradient_color_6 = "'${colors.base0E}'"; # mauve
        gradient_color_7 = "'${colors.base0F}'"; # flamingo
        gradient_color_8 = "'${colors.base08}'"; # red
      };

      general = {
        framerate = 60;
        bars = 0; # Auto-detect based on terminal width
      };

      smoothing = {
        noise_reduction = 77;
      };
    };
  };
}
