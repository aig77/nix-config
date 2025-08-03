{config, ...}: {
  imports = [
    ../../modules/darwin
    ../../modules/nixos/home-manager.nix
    ./theme.nix
    ./variables.nix
  ];

  system.primaryUser = config.var.username;
  home-manager.users.arturo = import ./home.nix;
}
