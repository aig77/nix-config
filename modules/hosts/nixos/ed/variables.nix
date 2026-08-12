_: {
  configurations.nixos.ed.module = {
    # TODO: declare LAN IPv4 here (var.network.hosts.ed = "192.168.68.101")
    # once the network topology registry exists in var/nixos.nix.
    var = {
      username = "arturo";
      hostname = "ed";
      shell = "zsh";
    };
  };
}
