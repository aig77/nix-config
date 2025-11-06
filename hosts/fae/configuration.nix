{
  config,
  lib,
  ...
}: {
  imports =
    [
      # Mostly system related configuration
      ../../modules/nixos/audio.nix
      ../../modules/nixos/avahi.nix
      ../../modules/nixos/boot.nix
      ../../modules/nixos/docker.nix
      ../../modules/nixos/home-manager.nix
      ../../modules/nixos/networking.nix
      ../../modules/nixos/nix.nix
      ../../modules/nixos/users.nix
      ../../modules/nixos/utils.nix

      #../../modules/nixos/hyprland.nix
      #../../modules/nixos/sddm.nix
      ../../modules/nixos/gnome.nix
      #../../modules/nixos/nvidia.nix
      ../../modules/nixos/amdgpu.nix
      ../../modules/nixos/gaming.nix

      ./variables.nix
      ./theme.nix
    ]
    ++ lib.optionals (builtins.pathExists ./hardware-configuration.nix) [
      ./hardware-configuration.nix
    ]
    ++ lib.optionals (!builtins.pathExists ./hardware-configuration.nix) [
      ./disko.nix
    ];

  home-manager.users.${config.var.username} = import ./home.nix;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  #system.stateVersion = "24.11"; # Did you read the comment?
  system.stateVersion = "25.05";
}
