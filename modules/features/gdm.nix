_: {
  flake.modules.nixos.gdm = _: {
    services.displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };
}
