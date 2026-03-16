{inputs, config, ...}: let
  builders = import ../../lib/builders.nix {inherit inputs;};
in {
  flake.darwinConfigurations.ein = builders.mkDarwin {
    modules = [
      # External
      inputs.home-manager.darwinModules.home-manager
      inputs.nix-homebrew.darwinModules.nix-homebrew
      inputs.sops-nix.darwinModules.sops
      inputs.stylix.darwinModules.stylix

      # Base
      config.flake.darwinModules.base
      config.flake.darwinModules.theming

      # Home-manager base (reuse sops passthrough)
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "hm-backup";
          extraSpecialArgs = {inherit inputs;};
        };
      }

      # Sops
      config.flake.nixosModules.sops

      # Host-specific
      ./_ein/configuration.nix
    ];
  };
}
