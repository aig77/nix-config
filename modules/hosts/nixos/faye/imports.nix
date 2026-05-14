{config, ...}: {
  configurations.nixos.faye.module = {
    imports = with config.flake.modules.nixos; [
      base
      desktop
      amdgpu
      htpc
      no-rgb
    ];
  };
}
