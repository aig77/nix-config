{
  flake.nixosModules.amdgpu = {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
