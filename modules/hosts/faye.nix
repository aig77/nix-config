{inputs, config, ...}: let
  builders = import ../../lib/builders.nix {inherit inputs;};
in {
  flake.nixosConfigurations.faye = builders.mkNixos {
    system = "x86_64-linux";
    modules = [
      # External
      inputs.sops-nix.nixosModules.sops
      inputs.disko.nixosModules.disko
      inputs.home-manager.nixosModules.home-manager
      inputs.stylix.nixosModules.stylix

      # Base
      config.flake.nixosModules.variables
      config.flake.nixosModules.nix-settings
      config.flake.nixosModules.utils
      config.flake.nixosModules.users
      config.flake.nixosModules.home-manager-base

      # Features
      config.flake.nixosModules.audio
      config.flake.nixosModules.boot
      config.flake.nixosModules.docker
      config.flake.nixosModules.hyprland
      config.flake.nixosModules.gaming
      config.flake.nixosModules.amdgpu
      config.flake.nixosModules.tailscale
      config.flake.nixosModules.thunar
      config.flake.nixosModules.sops
      config.flake.nixosModules.theming
      config.flake.nixosModules.git
      config.flake.nixosModules.zen

      # Host-specific
      ./_faye/hardware-configuration.nix
      ./_faye/disko-config.nix
      {
        var = {
          username = "arturo";
          hostname = "faye";
          location = "Miami";
          shell = "zsh";
          terminal = "ghostty";
          browser = "zen";
          launcher = "fuzzel";
          fileManager = "nautilus";
          lock = "hyprlock";
          logout = "wlogout";
        };
        home-manager.users.arturo = import ./_faye/home.nix;
        system.stateVersion = "25.05";
      }
    ];
  };
}
