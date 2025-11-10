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
          inputs.disko.nixosModules.disko
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
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
          inputs.stylix.darwinModules.stylix
          inputs.nix-homebrew.darwinModules.nix-homebrew
          ../hosts/darwin/${hostname}/configuration.nix
        ]
        ++ extraModules;
    };
}
