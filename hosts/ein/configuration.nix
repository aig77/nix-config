{
  inputs,
  config,
  ...
}: {
  imports = [
    ../../modules/darwin
    ../../modules/nixos/home-manager.nix
    ../../themes/onedark-darwin.nix
    ./variables.nix
  ];

  system.primaryUser = config.var.username;
  home-manager.users.arturo = import ./home.nix;
}
