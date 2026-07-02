{inputs, ...}: {
  flake.modules.nixos.wallpaperengine = {
    pkgs,
    config,
    ...
  }: {
    assertions = [
      {
        assertion = config.programs.steam.enable;
        message = "nixos.wallpaperengine requires nixos.gaming (Steam must be enabled)";
      }
    ];

    environment.systemPackages = [pkgs.linux-wallpaperengine];
  };

  flake.modules.homeManager.wallpaperengine = {
    imports = [inputs.simple-linux-wallpaperengine-gui.homeManagerModules.default];

    programs.simple-wallpaper-engine = {
      enable = true;
      xdgAutostart = true;
    };
  };
}
