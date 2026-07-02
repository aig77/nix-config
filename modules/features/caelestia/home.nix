_: {
  flake.modules.homeManager.caelestia = {
    inputs,
    config,
    pkgs,
    lib,
    ...
  }: let
    c = config.lib.stylix.colors;
    # Map Stylix base16 to Material Design 3 tokens for caelestia's scheme.json.
    # base0D=blue (primary), base0C=teal (secondary), base0E=purple (tertiary),
    # base08=red (error), base0B=green (success), base00-03=surfaces.
    schemeJson = pkgs.writeText "caelestia-scheme.json" (builtins.toJSON {
      name = "stylix";
      flavour = "dark";
      mode = "dark";
      colours = {
        primary_paletteKeyColor = c.base0D;
        secondary_paletteKeyColor = c.base0C;
        tertiary_paletteKeyColor = c.base0E;
        neutral_paletteKeyColor = c.base03;
        neutral_variant_paletteKeyColor = c.base03;
        background = c.base00;
        onBackground = c.base05;
        surface = c.base00;
        surfaceDim = c.base00;
        surfaceBright = c.base02;
        surfaceContainerLowest = c.base01;
        surfaceContainerLow = c.base01;
        surfaceContainer = c.base02;
        surfaceContainerHigh = c.base02;
        surfaceContainerHighest = c.base03;
        onSurface = c.base05;
        surfaceVariant = c.base02;
        onSurfaceVariant = c.base04;
        inverseSurface = c.base06;
        inverseOnSurface = c.base01;
        outline = c.base03;
        outlineVariant = c.base04;
        shadow = "000000";
        scrim = "000000";
        surfaceTint = c.base0D;
        primary = c.base0D;
        onPrimary = c.base00;
        primaryContainer = c.base02;
        onPrimaryContainer = c.base0D;
        inversePrimary = c.base0D;
        secondary = c.base0C;
        onSecondary = c.base00;
        secondaryContainer = c.base03;
        onSecondaryContainer = c.base0C;
        tertiary = c.base0E;
        onTertiary = c.base00;
        tertiaryContainer = c.base02;
        onTertiaryContainer = c.base0E;
        error = c.base08;
        onError = c.base00;
        errorContainer = c.base02;
        onErrorContainer = c.base08;
        success = c.base0B;
        onSuccess = c.base00;
        successContainer = c.base02;
        onSuccessContainer = c.base0B;
        primaryFixed = c.base0D;
        primaryFixedDim = c.base0D;
        onPrimaryFixed = c.base00;
        onPrimaryFixedVariant = c.base02;
        secondaryFixed = c.base0C;
        secondaryFixedDim = c.base0C;
        onSecondaryFixed = c.base00;
        onSecondaryFixedVariant = c.base02;
        tertiaryFixed = c.base0E;
        tertiaryFixedDim = c.base0E;
        onTertiaryFixed = c.base00;
        onTertiaryFixedVariant = c.base02;
        term0 = c.base00;
        term1 = c.base08;
        term2 = c.base0B;
        term3 = c.base0A;
        term4 = c.base0D;
        term5 = c.base0E;
        term6 = c.base0C;
        term7 = c.base05;
        term8 = c.base03;
        term9 = c.base08;
        term10 = c.base0B;
        term11 = c.base0A;
        term12 = c.base0D;
        term13 = c.base0E;
        term14 = c.base0C;
        term15 = c.base07;
      };
    });
  in {
    imports = [
      inputs.caelestia.homeManagerModules.default
    ];

    programs.caelestia = {
      enable = true;
      cli.enable = true;
      settings = {
        general.apps.explorer = ["thunar"];
        appearance.font = {
          headline.family = config.stylix.fonts.sansSerif.name;
          title.family = config.stylix.fonts.sansSerif.name;
          body.family = config.stylix.fonts.sansSerif.name;
          label.family = config.stylix.fonts.sansSerif.name;
          mono.family = config.stylix.fonts.monospace.name;
        };
        services.smartScheme = false;
      };
    };

    # Write Stylix-derived scheme to caelestia state on each activation.
    # Uses install -m 644 so caelestia can overwrite at runtime if user changes scheme via UI.
    home.activation.caelestiaScheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p "$HOME/.local/state/caelestia"
      install -m 644 ${schemeJson} "$HOME/.local/state/caelestia/scheme.json"
    '';
  };
}
