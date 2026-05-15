_: {
  flake.modules.homeManager.discord = _: {
    programs.discord = {
      enable = true;
      settings = {
        SKIP_HOST_UPDATE = true;
        MINIMIZE_TO_TRAY = false;
      };
    };
  };
}
