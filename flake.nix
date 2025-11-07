{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devenv.url = "github:cachix/devenv";
    hyprland.url = "github:hyprwm/Hyprland";
    stylix.url = "github:danth/stylix";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nix-ai-tools.url = "github:numtide/nix-ai-tools";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-anywhere = {
      url = "github:nix-community/nixos-anywhere";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.disko.follows = "disko";
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

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
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

    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    flake-parts,
    devenv,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        devenv.flakeModule
      ];

      systems = ["x86_64-linux" "aarch64-darwin"];

      perSystem = {system, ...}: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.allowBroken = true;
        };
      in {
        devenv = import ./lib/devenv.nix {inherit pkgs;};
      };

      flake = let
        lib = import ./lib/mkSystem.nix {inherit inputs;};
      in {
        nixosConfigurations = {
          fae = lib.mkNixos {hostname = "fae";};
        };

        darwinConfigurations = {
          ein = lib.mkDarwin {hostname = "ein";};
          spike = lib.mkDarwin {hostname = "spike";};
        };
      };
    };
}
