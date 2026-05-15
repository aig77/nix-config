_: {
  flake.modules.homeManager.git = _: {
    programs.git = {
      enable = true;
      settings = {
        user.email = "git.lunchroom670@simplelogin.com";
        user.name = "Arturo";
      };
    };
  };
}
