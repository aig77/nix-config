{pkgs, ...}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  boot.kernelParams = ["nvidia-drm.modeset=1"];

  environment.variables = {
    LIBVA_DRIVER_NAME = "nvidia"; # Hardware video acceleration
    __GLX_VENDOR_LIBRARY_NAME = "nvidia"; # Use nvidia driver for GLX
    NVD_BACKEND = "direct"; # VA-API Hardware video acceleration
    GBM_BACKEND = "nvidia-drm"; # Graphics backend for Wayland
  };

  nixpkgs.config = {
    nvidia.acceptLicense = true;
    allowUnfree = true;
  };

  hardware.nvidia = {
    open = false;
    nvidiaSettings = false; # Nvidia settings utility
    modesetting.enable = true; # Required for Wayland
    powerManagement.enable = true; # Suspend/wakeup issues
  };
}
