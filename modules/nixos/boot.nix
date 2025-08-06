{
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      useOSProber = true;
      devices = ["nodev"];
    };
    efi.canTouchEfiVariables = true;
  };
}
