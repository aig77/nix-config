_: {
  flake.modules.homeManager.quickshell = {
    pkgs,
    config,
    osConfig,
    ...
  }: let
    colors = config.lib.stylix.colors.withHashtag;
    font = config.stylix.fonts.monospace.name;
  in {
    home = {
      packages = with pkgs; [quickshell qt6.qtwayland libnotify];

      # Enables GET on a local file
      sessionVariables.QML_XHR_ALLOW_FILE_READ = "1";

      # Generated files are written to ~/.cache/stylix/ to avoid conflicting
      # with the symlinked config directory above.
      file = {
        # Consumed by Config.qml to set colorSource, font, and MD3 colors for the overview.
        # Colors embedded here so Appearance.qml can read them via the already-working
        # Config process (which uses $HOME) rather than relative QML URL resolution.
        # Regenerated on every rebuild.
        ".cache/bebop/weather.json".text = builtins.toJSON {
          location = osConfig.var.location;
          weatherApiKeyPath =
            if osConfig ? sops && (osConfig.sops.templates ? "weatherapi.json")
            then osConfig.sops.templates."weatherapi.json".path
            else "";
        };

        ".cache/stylix/config.json".text = builtins.toJSON {
          appearance = {
            colorSource = "matugen";
            matugenColors = {
              m3primary = colors.base0D; # blue
              m3onPrimary = colors.base00; # bg
              m3primaryContainer = colors.base02; # surface
              m3onPrimaryContainer = colors.base05; # fg
              m3secondary = colors.base0E; # purple
              m3onSecondary = colors.base00; # bg
              m3secondaryContainer = colors.base03; # muted
              m3onSecondaryContainer = colors.base05; # fg
              m3background = colors.base00; # bg
              m3onBackground = colors.base05; # fg
              m3surface = colors.base00; # bg
              m3surfaceContainerLow = colors.base01; # mantle
              m3surfaceContainer = colors.base02; # surface
              m3surfaceContainerHigh = colors.base03; # muted
              m3surfaceContainerHighest = colors.base04; # subtle
              m3onSurface = colors.base05; # fg
              m3surfaceVariant = colors.base02; # surface
              m3onSurfaceVariant = colors.base05; # fg
              m3inverseSurface = colors.base05; # fg
              m3inverseOnSurface = colors.base00; # bg
              m3outline = colors.base03; # muted
              m3outlineVariant = colors.base02; # surface
              m3shadow = "#000000";
            };
            font.family = {
              main = "${font}";
              title = "${font}";
              expressive = "${font}";
            };
          };
        };
      };
    };

    # Symlink the entire quickshell config directory from the repo.
    # Edits take effect immediately without a rebuild.
    xdg.configFile."quickshell".source =
      config.lib.file.mkOutOfStoreSymlink "${osConfig.var.repoPath}/modules/features/quickshell/quickshell";
  };
}
