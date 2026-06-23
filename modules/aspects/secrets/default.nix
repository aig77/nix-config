_: {
  flake.modules.nixos.base = _: {
    sops = {
      defaultSopsFile = ./secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "/etc/sops/age/keys.txt";
      secrets = {};
    };
  };
}
