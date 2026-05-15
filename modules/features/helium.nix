_: {
  flake.modules.nixos.helium = _: {
    stylix.targets.chromium.enable = false;
  };

  flake.modules.homeManager.helium = {
    lib,
    config,
    inputs,
    pkgs,
    ...
  }: {
    options.programs.helium.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Helium browser";
    };

    config = lib.mkIf (config.programs.helium.enable && pkgs.stdenv.isLinux) {
      home.packages = [inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default];
    };
  };
}
