_: {
  flake.modules.homeManager.vesktop = _: {
    programs.vesktop = {
      enable = false;
      settings = {
        minimizeToTray = false;
        hardwareAcceleration = true;
        hardwareVideoAcceleration = true;
      };
    };
  };
}
