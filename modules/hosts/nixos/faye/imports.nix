{config, ...}: {
  configurations.nixos.faye.module = {
    imports = with config.flake.modules.nixos; [
      base
      amdgpu
      htpc
      steamos
      no-rgb
    ];
  };
}
