{config, ...}: let
  modulesPath = ../../../modules;
  themesPath = ../../../themes;
in {
  imports = [
    # Mostly system related configuration
    (modulesPath + /nixos/audio.nix)
    (modulesPath + /nixos/boot.nix)
    (modulesPath + /nixos/docker.nix)
    (modulesPath + /nixos/nix.nix)
    (modulesPath + /nixos/users.nix)
    (modulesPath + /nixos/utils.nix)

    # WM
    # (modulesPath + /nixos/gnome.nix)
    # (modulesPath + /nixos/hyprland.nix)
    (modulesPath + /nixos/niri.nix)

    # Gaming
    (modulesPath + /nixos/amdgpu.nix)
    (modulesPath + /nixos/gaming.nix)

    (modulesPath + /common/home-manager.nix)
    (modulesPath + /common/sops.nix)

    (themesPath + /catppuccin-linux.nix)

    ./disko-config.nix
    ./hardware-configuration.nix
    ./variables.nix
  ];

  home-manager.users.${config.var.username} = import ./home.nix;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
