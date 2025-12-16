{
  config,
  lib,
  pkgs,
  ...
}: let
  modulesPath = ../../../modules;
in {
  imports = [
    # Mostly system related configuration
    (modulesPath + /nixos/nix.nix)
    (modulesPath + /nixos/users.nix)
    (modulesPath + /nixos/utils.nix)

    (modulesPath + /server/dns.nix)
    (modulesPath + /common/sops.nix)

    ./hardware-configuration.nix
    ./variables.nix
  ];

  # System monitoring and utilities
  environment.systemPackages = with pkgs; [
    btop
  ];

  # Raspberry Pi dedicated DNS server - auto-boot and auto-login
  boot = {
    kernelPackages = lib.mkForce pkgs.linuxPackages;
    loader = lib.mkForce {
      generic-extlinux-compatible.enable = true;
      grub.enable = false;
    };
    # Auto-boot after power loss
    kernelParams = ["boot.shell_on_fail"];
  };

  # Auto-login to prevent interactive boot
  services.getty.autologinUser = config.var.username;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
