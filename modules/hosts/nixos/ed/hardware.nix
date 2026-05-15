_: {
  configurations.nixos.ed.module = _: {
    boot = {
      loader = {
        grub.enable = false;
        generic-extlinux-compatible.enable = true;
      };
      growPartition = true;
      tmp.useTmpfs = true;
      kernelParams = [
        "panic=10"
        "boot.shell_on_fail"
      ];
      kernelModules = ["bcm2835_wdt"];
    };

    systemd.settings.Manager = {
      RebootWatchdogSec = "10min";
      RuntimeWatchdogSec = "60s";
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/NIXOS_SD";
        fsType = "ext4";
        options = ["noatime"];
      };
    };

    hardware.enableRedistributableFirmware = true;
  };
}
