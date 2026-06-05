_: {
  flake.modules.nixos.git = {config, ...}: {
    sops.secrets."git/email".owner = config.var.username;
    sops.templates."gitconfig-email" = {
      # email is a sops secret - written to a file at runtime and included by git
      content = "[user]\n  email = ${config.sops.placeholder."git/email"}\n";
      owner = config.var.username;
    };
  };

  flake.modules.darwin.git = {config, ...}: {
    sops.secrets."git/email".owner = config.var.username;
    sops.templates."gitconfig-email" = {
      content = "[user]\n  email = ${config.sops.placeholder."git/email"}\n";
      owner = config.var.username;
    };
  };

  flake.modules.homeManager.git = {osConfig, ...}: {
    programs.git = {
      enable = true;
      settings.user.name = "Arturo";
      includes = [{path = osConfig.sops.templates."gitconfig-email".path;}];
    };
  };
}
