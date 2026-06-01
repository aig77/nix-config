{config, ...}: {
  configurations.nixos.faye.module = {inputs, ...}: {
    facter.reportPath = ./facter.json;
    imports =
      [inputs.nixos-facter-modules.nixosModules.facter]
      ++ (with config.flake.modules.nixos; [
        base
        amdgpu
        htpc
        steamos
        no-rgb
        tailscale
      ]);
  };
}
