{inputs, ...}: let
  builders = import ../../lib/builders.nix {inherit inputs;};
in {
  configurations.nixos.faye = builders.mkNixos {
    hostname = "faye";
    system = "x86_64-linux";
    overlays = [inputs.niri.overlays.niri];
    extraModules = [
      inputs.disko.nixosModules.disko
      inputs.home-manager.nixosModules.home-manager
      inputs.stylix.nixosModules.stylix
    ];
  };
}
