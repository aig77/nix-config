{

  description = "My system configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland"; 
    stylix.url = "github:danth/stylix";
    swww.url = "github:LGFae/swww";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
  };
  
  outputs = { self, nixpkgs, nixpkgs-stable, ... } @inputs: 
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-stable = nixpkgs-stable.legacyPackages.${system};
    in { 
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system; 
        specialArgs = { inherit inputs; };
        modules = [ 
          ./hosts/laptop/configuration.nix # CHANGEME: change the path to match your host folder 
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
        ];
      };
    };
  };
}
