{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-24.11";
    hyprland.url = "github:hyprwm/Hyprland";
    stylix.url = "github:danth/stylix";
    nixcord.url = "github:kaylorben/nixcord";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-stable, ... }:
    let
      system = "x86_64-linux";
      aarch = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-stable = nixpkgs-stable.legacyPackages.${system};
    in {
      nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/thinkpad/configuration.nix # CHANGEME: change the path to match your host folder
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
        ];
      };

      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/desktop/configuration.nix # CHANGEME: change the path to match your host folder
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
        ];
      };
      
      darwinConfigurations.macbook = inputs.nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin"; 
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/macbook/configuration.nix # CHANGEME: change the path to match your host folder
          inputs.home-manager.darwinModules.home-manager
          inputs.stylix.darwinModules.stylix
        ];
      };      
      
      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations.macbook.pkgs;
      
      # for `nix fmt`
      formatter.${system} = pkgs.nixfmt;

      # nix develop
      devShells.${system}.default = import ./shell.nix { inherit pkgs; };
    };
}
