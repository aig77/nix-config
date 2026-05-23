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
        # Base16 palette consumed by Colors.qml at runtime.
        ".cache/stylix/colors.json".text = builtins.toJSON {
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

        # Loaded by Appearance.qml when colorSource = "matugen".
        # Maps the base16 Stylix palette to Material Design 3 roles.
        # Regenerated on every rebuild.
        ".cache/stylix/Appearance.colors.qml".text = ''
          import QtQuick

          QtObject {
              id: m3

              property color m3primary: "${colors.base0D}"             // blue
              property color m3onPrimary: "${colors.base00}"           // bg

              property color m3primaryContainer: "${colors.base02}"    // surface
              property color m3onPrimaryContainer: "${colors.base05}"  // fg

              property color m3secondary: "${colors.base0E}"           // purple
              property color m3onSecondary: "${colors.base00}"         // bg

              property color m3secondaryContainer: "${colors.base03}"  // muted
              property color m3onSecondaryContainer: "${colors.base05}" // fg

              property color m3background: "${colors.base00}"          // bg
              property color m3onBackground: "${colors.base05}"        // fg

              property color m3surface: "${colors.base00}"             // bg

              property color m3surfaceContainerLow: "${colors.base01}"  // mantle
              property color m3surfaceContainer: "${colors.base02}"     // surface
              property color m3surfaceContainerHigh: "${colors.base03}" // muted
              property color m3surfaceContainerHighest: "${colors.base04}" // subtle

              property color m3onSurface: "${colors.base05}"           // fg

              property color m3surfaceVariant: "${colors.base02}"      // surface
              property color m3onSurfaceVariant: "${colors.base05}"    // fg

              property color m3inverseSurface: "${colors.base05}"      // fg
              property color m3inverseOnSurface: "${colors.base00}"    // bg

              property color m3outline: "${colors.base03}"             // muted
              property color m3outlineVariant: "${colors.base02}"      // surface

              property color m3shadow: "#000000"
          }
        '';

        # Consumed by Config.qml to set colorSource and font for the overview.
        # Regenerated on every rebuild.
        ".cache/stylix/config.json".text = builtins.toJSON {
          appearance = {
            colorSource = "matugen";
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
