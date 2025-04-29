{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-24.11";
    stylix.url = "github:danth/stylix";
    hyprland.url = "github:hyprwm/Hyprland";
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
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-stable, ... }:
    let
      system = "x86_64-linux";
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
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
          config.allowBroken = true;
        };
        modules = [
          ./hosts/macbook/configuration.nix # CHANGEME: change the path to match your host folder
          inputs.home-manager.darwinModules.home-manager
          inputs.stylix.darwinModules.stylix
          inputs.nix-homebrew.darwinModules.nix-homebrew
        ];
      };      
      
      # for `nix fmt`
      formatter.${system} = pkgs.nixfmt;

      # nix develop
      devShells.${system}.default = import ./shell.nix { inherit pkgs; };
    };
}
