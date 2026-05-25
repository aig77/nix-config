_: {
  flake.modules.nixos.sddm = {
    pkgs,
    config,
    ...
  }: let
    colors = config.lib.stylix.colors.withHashtag;
    font = config.stylix.fonts.monospace.name;
    sddmTheme = pkgs.sddm-astronaut.override {
      embeddedTheme = "astronaut";
      themeConfig = {
        Background = "/var/lib/sddm/wallpaper";
        PartialBlur = "true";
        BlurRadius = "50";
        FormPosition = "center";
        AccentColor = colors.base0E;
        BackgroundColor = colors.base00;
        Font = font;
      };
    };
  in {
    services.displayManager.sddm = {
      enable = true;
      package = pkgs.kdePackages.sddm;
      theme = "sddm-astronaut-theme";
      extraPackages = [pkgs.kdePackages.qtmultimedia];
    };

    environment.systemPackages = [sddmTheme];

    # System service syncs wallpaper before SDDM starts at boot
    systemd = {
      services.sddm-wallpaper-sync = {
        description = "Sync desktop wallpaper to SDDM";
        before = ["display-manager.service"];
        wantedBy = ["display-manager.service"];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.coreutils}/bin/cp /home/${config.var.username}/.cache/bebop/current-wallpaper /var/lib/sddm/wallpaper";
        };
      };

      # User path unit re-syncs when wallpaper changes during a session
      user = {
        services.sddm-wallpaper-sync = {
          description = "Sync desktop wallpaper to SDDM";
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${pkgs.coreutils}/bin/cp %h/.cache/bebop/current-wallpaper /var/lib/sddm/wallpaper";
          };
        };

        paths.sddm-wallpaper-sync = {
          description = "Watch desktop wallpaper for changes";
          pathConfig.PathChanged = "%h/.cache/bebop/current-wallpaper";
          wantedBy = ["default.target"];
        };
      };

      tmpfiles.rules = [
        "d /var/lib/sddm 0755 sddm sddm -"
        "f /var/lib/sddm/wallpaper 0666 root root -"
      ];
    };
  };
}
