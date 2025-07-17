{
  hooks = {
    alejandra.enable = true;
    deadnix.enable = true;
    statix = {
      enable = true;
      settings.ignore = ["hardware-configuration.nix"];
    };
  };
}
