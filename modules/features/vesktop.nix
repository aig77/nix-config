_: {
  flake.modules.homeManager.vesktop = _: {
    programs.vesktop = {
      enable = true;
      settings = {
        minimizeToTray = false;
        hardwareAcceleration = true;
        hardwareVideoAcceleration = true;
      };
    };
  };
}
