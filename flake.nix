{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    hyprland.url = "github:hyprwm/Hyprland";
    stylix.url = "github:danth/stylix";
    rust-overlay.url = "github:oxalica/rust-overlay";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    nixcord.url = "github:kaylorben/nixcord";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    home-manager = {
      url = "github:nix-community/home-manager";
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

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    home-manager,
    stylix,
    hyprpanel,
    darwin,
    nix-homebrew,
    treefmt-nix,
    rust-overlay,
    ...
  }: let
    systems = [ "x86_64-linux" "aarch64-darwin" ];
    commonOverlays = [rust-overlay.overlays.default];
  in
    flake-parts.lib.mkFlake { inherit inputs; } {
      inherit systems;

      perSystem = { system, ...}: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = commonOverlays;
        };
        treefmtEval = treefmt-nix.lib.evalModule pkgs ./tools/treefmt.nix;
      in {
        formatter = treefmtEval.config.build.wrapper;
        checks.formatting = treefmtEval.config.build.check self;
        devShells.default = import ./shell.nix { inherit pkgs; };
      };

      flake = {
        nixosConfigurations = {
        thinkpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {inherit inputs;};
          modules = [
            home-manager.nixosModules.home-manager
            stylix.nixosModules.stylix
            ./hosts/thinkpad/configuration.nix
          ];
        };
        spike = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {inherit inputs;};
          modules = [
            home-manager.nixosModules.home-manager
            stylix.nixosModules.stylix
            ./hosts/spike/configuration.nix
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
