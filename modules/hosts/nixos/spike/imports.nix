{config, ...}: {
  configurations.nixos.spike.module = {inputs, ...}: {
    imports =
      [inputs.nixos-facter-modules.nixosModules.facter ./facter.json]
      ++ (with config.flake.modules.nixos; [
        base
        desktop
        hyprland-quickshell
        amdgpu
        gaming
        docker
        tailscale
        volt
      ]);
  };
}
