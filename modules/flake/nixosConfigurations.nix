{
  lib,
  config,
  inputs,
  ...
}: {
  options.configurations.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.submodule {
      options.module = lib.mkOption {
        type = lib.types.deferredModule;
      };
    });
    default = {};
  };

  config.flake.nixosConfigurations =
    lib.mapAttrs (
      _name: {module}:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [
            {
              nixpkgs.config = {
                allowUnfree = true;
                allowBroken = true;
                # bitwarden-desktop hardcodes electron_39 in nixpkgs despite upstream
                # having moved to electron 34+. Remove once nixpkgs updates the package.
                # Track: https://github.com/NixOS/nixpkgs/issues/526914
                permittedInsecurePackages = [
                  "electron-39.8.10"
                ];
              };
            }
            inputs.sops-nix.nixosModules.sops
            module
          ];
        }
    )
    config.configurations.nixos;
}
