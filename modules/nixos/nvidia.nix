{pkgs, ...}: {
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
    nvidiaSettings = true; # Nvidia settings utility
    modesetting.enable = true; # Required for Wayland
    powerManagement.enable = true; # Suspend/wakeup issues
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [libva];
  };

  services.pipewire = {
    # Add this part:
    extraConfig.pipewire = {
      "context.modules" = [
        {
          name = "libpipewire-module-spa-node-factory";
          args = {
            "factory.name" = "support.node.driver";
            "node.name" = "driver";
            "priority.driver" = 1;
            "autoconnect" = true;
            "flags" = ["no-dmabuf"];
          };
        }
      ];
    };
  };
}
