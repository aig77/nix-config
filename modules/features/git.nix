_: {
  flake.modules.homeManager.git = {osConfig, ...}: {
    programs.git = {
      enable = true;
      settings = {
        user.name = osConfig.var.git.name;
        user.email = osConfig.var.git.email;
      };
    };
  };
}
