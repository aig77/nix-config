{inputs, ...}: let
  builders = import ../../lib/builders.nix {inherit inputs;};
in {
  configurations.darwin.ein = builders.mkDarwin {hostname = "ein";};
}
