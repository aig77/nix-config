{config, ...}: let
  secretsDir = ../../secrets;
in {
  sops = {
    defaultSopsFile = secretsDir + /secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.users.users.${config.var.username}.home}/.config/sops/age/keys.txt";

    secrets = {
      github-email = {};
    };
  };
}
