_: {
  flake.modules.homeManager.git = {var, ...}: {
    programs.git = {
      enable = true;
      settings = {
        user.name = var.username;
      };
    };
  };
}
