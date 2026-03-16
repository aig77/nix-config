{inputs, ...}: let
  builders = import ../../lib/builders.nix {inherit inputs;};
in {
  flake.packages.aarch64-linux = {
    ed-sdimage = builders.mkSdImage {
      hostname = "ed";
      extraModules = [inputs.sops-nix.nixosModules.sops];
    };
  };
}
