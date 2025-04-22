{ pkgs, ... }: {
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      grub = {
        enable = true;
        #device = "/dev/sda";
        devices = [ "nodev" ];
        efiSupport = true; 
        useOSProber = true;
      };
    };
  };
}
