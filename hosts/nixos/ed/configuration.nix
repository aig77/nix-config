{
  config,
  pkgs,
  ...
}: let
  modulesPath = ../../../modules;
in {
  imports = [
    # Mostly system related configuration
    (modulesPath + /nixos/nix.nix)
    (modulesPath + /nixos/users.nix)

    (modulesPath + /server/dns.nix)
    (modulesPath + /common/sops.nix)

    ./variables.nix
  ];

  networking.hostName = config.var.hostname;

  boot = {
    kernelPackages = pkgs.linuxPackages;
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    # Auto-expand root partition on first boot
    growPartition = true;
    # keeps /tmp writes off the SD
    tmp.useTmpfs = true;
    # Auto-reboot on kernel panic after 10 seconds
    kernelParams = [
      "panic=10"
      "boot.shell_on_fail"
    ];
  };

  # Hardware watchdog for auto-reboot if system hangs
  systemd.settings.Manager = {
    RebootWatchdogSec = "10min";
    RuntimeWatchdogSec = "60s";
  };
  boot.kernelModules = ["bcm2835_wdt"];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
  };

  services = {
    # Auto-login to prevent interactive boot
    getty.autologinUser = config.var.username;
    openssh.enable = true;
  };

  hardware.enableRedistributableFirmware = true;

  environment.systemPackages = with pkgs; [
    htop
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
