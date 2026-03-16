{inputs, config, ...}: let
  builders = import ../../lib/builders.nix {inherit inputs;};
in {
  flake.nixosConfigurations.ed = builders.mkNixos {
    system = "aarch64-linux";
    modules = [
      # External
      inputs.sops-nix.nixosModules.sops

      # Base
      config.flake.nixosModules.variables
      config.flake.nixosModules.nix-settings
      config.flake.nixosModules.users

      # Features
      config.flake.nixosModules.sops
      config.flake.nixosModules.dns

      # Host-specific
      ./_ed/configuration.nix
    ];
  };
}
