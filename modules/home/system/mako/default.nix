{config, ...}: let
  colors = config.lib.stylix.colors.withHashtag;
in {
  services.mako = {
    enable = true;

    # Behavior
    defaultTimeout = 5000; # 5 seconds
    ignoreTimeout = true; # respect app-specified timeouts

    # Position
    anchor = "top-right";
    margin = "20";
    padding = "15";

    # Appearance
    width = 350;
    height = 150;
    borderSize = 2;
    borderRadius = 12;

    # Colors
    backgroundColor = "${colors.base00}dd"; # ~87% opacity
    textColor = "${colors.base05}";
    borderColor = "${colors.base0D}";
    progressColor = "over ${colors.base02}";

    # Urgency-specific colors
    extraConfig = ''
      [urgency=low]
      border-color=${colors.base0D}

      [urgency=normal]
      border-color=${colors.base0D}

      [urgency=high]
      border-color=${colors.base08}
      default-timeout=0
    '';

    # Font
    font = "${config.stylix.fonts.sansSerif.name} 11";

    # Icons
    iconPath = "${config.home.homeDirectory}/.local/share/icons";
    maxIconSize = 48;

    # Actions
    actions = true;
  };
}
