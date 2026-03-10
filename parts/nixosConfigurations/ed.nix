{inputs, ...}: let
  builders = import ../../lib/builders.nix {inherit inputs;};
in {
  configurations.nixos.ed = builders.mkNixos {
    hostname = "ed";
    system = "aarch64-linux";
  };
}
