_: {
  flake.modules.nixos.base = {config, ...}: {
    sops = {
      defaultSopsFile = ./secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "${config.users.users.${config.var.username}.home}/.config/sops/age/keys.txt";
      secrets = {};
    };
  };
}
