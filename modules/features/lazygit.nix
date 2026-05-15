_: {
  flake.modules.homeManager.lazygit = _: {
    programs.lazygit = {
      enable = true;
    };
  };
}
