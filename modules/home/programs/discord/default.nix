{inputs, ...}: {
  imports = [inputs.nixcord.homeModules.nixcord];

  programs.nixcord = {
    enable = true;
    config = {
      frameless = true;
      plugins = {
        alwaysAnimate.enable = true;
        fakeNitro.enable = true;
      };
    };
  };
}
