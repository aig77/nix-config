_: {
  flake.modules.homeManager.nixcord = {inputs, ...}: {
    imports = [inputs.nixcord.homeModules.nixcord];

    programs.nixcord = {
      enable = true;
      discord.enable = false;
      vesktop = {
        enable = true;
        settings.minimizeToTray = "off";
      };
      config = {
        frameless = true;
        plugins = {
          alwaysAnimate.enable = true;
          betterFolders.enable = true;
          fakeNitro.enable = true;
          imageZoom.enable = true;
          readAllNotificationsButton.enable = true;
        };
      };
    };
  };
}
