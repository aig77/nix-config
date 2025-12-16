{inputs, ...}: {
  mkNixos = {
    hostname,
    system ? "x86_64-linux",
    overlays ? [],
    extraModules ? [],
  }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs hostname;};
      modules =
        [
          {
            nixpkgs.config = {
              allowUnfree = true;
              allowBroken = true;
            };
            nixpkgs.overlays = overlays;
          }
          ../hosts/nixos/${hostname}/configuration.nix
        ]
        ++ extraModules;
    };

  mkDarwin = {
    hostname,
    system ? "aarch64-darwin",
    overlays ? [],
    extraModules ? [],
  }:
    inputs.darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit inputs hostname;
      };
      modules =
        [
          {
            nixpkgs.config = {
              allowUnfree = true;
              allowBroken = true;
            };
            nixpkgs.overlays = overlays;
          }
          inputs.home-manager.darwinModules.home-manager
          inputs.nix-homebrew.darwinModules.nix-homebrew
          inputs.sops-nix.darwinModules.sops
          inputs.stylix.darwinModules.stylix
          ../hosts/darwin/${hostname}/configuration.nix
        ]
        ++ extraModules;
    };
}
