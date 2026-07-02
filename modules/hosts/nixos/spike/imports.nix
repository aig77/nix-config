{config, ...}: {
  configurations.nixos.spike.module = {inputs, ...}: {
    facter.reportPath = ./facter.json;
    imports =
      [inputs.nixos-facter-modules.nixosModules.facter]
      ++ (with config.flake.modules.nixos; [
        base
        desktop
        hyprland-noctalia
        amdgpu
        gaming
        docker
        tailscale
        volt
      ]);
  };
}
