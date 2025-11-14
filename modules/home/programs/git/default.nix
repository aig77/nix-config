{
  config,
  sops,
  ...
}: {
  programs.git = {
    enable = true;
    settings = {
      user.name = config.var.username;
      user.email = sops.secrets.git-email.path;
    };
  };
}
