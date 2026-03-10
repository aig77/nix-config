{inputs, ...}: let
  builders = import ../../lib/builders.nix {inherit inputs;};
in {
  configurations.darwin.spike = builders.mkDarwin {hostname = "spike";};
}
