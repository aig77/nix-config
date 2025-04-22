{
  services.xserver.videoDrivers = [ "nvidia" ];

  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

  environment.variables = {
    LIBVA_DRIVER_NAME = "nvidia"; # Hardware video acceleration
    GDM_BACKEND = "nvidia-drm"; # Graphics backend for Wayland
    __GLX_VENDOR_LIBRARY_NAME = "nvidia"; # Use nvidia driver for GLX
  };

  nixpkgs.config = {
    nvidia.acceptLicense = true;
    allowUnfree = true;
  };

  hardware.nvidia = {
    open = false;
    nvidiaSettings = true; # Nvidia settings utility
    modesetting.enable = true; # Required for Wayland
  };
}
