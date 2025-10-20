{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devenv.url = "github:cachix/devenv";
    hyprland.url = "github:hyprwm/Hyprland";
    stylix.url = "github:danth/stylix";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    ghostty.url = "github:ghostty-org/ghostty";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
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

    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    flake-parts,
    devenv,
    home-manager,
    stylix,
    darwin,
    nix-homebrew,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        devenv.flakeModule
      ];

      systems = ["x86_64-linux" "aarch64-darwin"];

      perSystem = {
        system,
        config,
        ...
      }: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.allowBroken = true;
        };
      in {
        devenv = import ./devenv.nix {inherit pkgs;};
      };

      flake = {
        nixosConfigurations = {
          fae = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {inherit inputs;};
            modules = [
              home-manager.nixosModules.home-manager
              stylix.nixosModules.stylix
              ./hosts/fae/configuration.nix
            ];
          };
        };

        darwinConfigurations = {
          # macbook pro
          ein = darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            specialArgs = {inherit inputs;};
            modules = [
              home-manager.darwinModules.home-manager
              stylix.darwinModules.stylix
              nix-homebrew.darwinModules.nix-homebrew
              ./hosts/ein/configuration.nix
            ];
          };
        };
      };
    };
}
# rebuild Mon Oct 20 14:06:47 EDT 2025

