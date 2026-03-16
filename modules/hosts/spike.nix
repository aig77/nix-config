{inputs, config, ...}: let
  builders = import ../../lib/builders.nix {inherit inputs;};
in {
  flake.darwinConfigurations.spike = builders.mkDarwin {
    modules = [
      # External
      inputs.home-manager.darwinModules.home-manager
      inputs.nix-homebrew.darwinModules.nix-homebrew
      inputs.sops-nix.darwinModules.sops
      inputs.stylix.darwinModules.stylix

      # Base
      config.flake.darwinModules.base
      config.flake.darwinModules.theming

      # Home-manager base
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
      ./_spike/configuration.nix
    ];
  };
}
