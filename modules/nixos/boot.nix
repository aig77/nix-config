{pkgs, ...}: {
  boot = {
    # kernelPackages = pkgs.linuxPackages_latest; # Latest stable kernel
    kernelPackages = pkgs.linuxPackages_zen;

    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        useOSProber = true;
        devices = ["nodev"];
      };
      efi.canTouchEfiVariables = true;
    };
  };
}
