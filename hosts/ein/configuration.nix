{config, ...}: {
  imports = [
    ../../modules/darwin
    ../../modules/nixos/home-manager.nix
    ./variables.nix
    ./theme.nix
  ];

  system.primaryUser = config.var.username;
  home-manager.users.arturo = import ./home.nix;
}
