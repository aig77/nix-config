# For x86_64-linux machines that want to build aarch64-linux images
# E.g machines that would want to build on host ed
_: {
  flake.modules.nixos.aarch64-builder = {
    boot.binfmt.emulatedSystems = ["aarch64-linux"];
  };
}
