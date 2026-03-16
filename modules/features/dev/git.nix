{
  flake.nixosModules.git = {config, ...}: {
    home-manager.users.${config.var.username} = {sops, ...}: {
      programs.git = {
        enable = true;
        settings = {
          user.name = config.var.username;
          user.email = sops.secrets.git-email.path;
        };
      };
    };
  };
}
