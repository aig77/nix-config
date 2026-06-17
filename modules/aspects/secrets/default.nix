_: {
  flake.modules.nixos.base = {config, ...}: {
    sops = {
      defaultSopsFile = ./secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "/etc/sops/age/keys.txt";
      secrets = {};
    };
  };
}
