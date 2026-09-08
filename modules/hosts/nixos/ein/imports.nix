{config, ...}: {
  configurations.nixos.ein.module = {inputs, ...}: {
    facter.reportPath = ./facter.json;
    imports =
      [inputs.nixos-facter-modules.nixosModules.facter]
      ++ (with config.flake.modules.nixos; [
        base
        laptop
        hyprland-noctalia
        niri
        intelgpu
        gaming
        docker
      ]);
  };
}
