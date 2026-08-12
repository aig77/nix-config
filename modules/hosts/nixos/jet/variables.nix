_: {
  configurations.nixos.jet.module = {
    # TODO: declare own LAN IPv4 here (var.network.hosts.jet = "...") once the
    # network topology registry exists in var/nixos.nix.
    var = {
      username = "arturo";
      hostname = "jet";
      shell = "zsh";
    };
  };
}
