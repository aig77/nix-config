{ inputs,  ... }: {
  imports = [
    ../../modules/darwin
    ../../modules/nixos/home-manager.nix
    ./variables.nix
  ];
  
  home-manager.users.arturo = import ./home.nix;
}
