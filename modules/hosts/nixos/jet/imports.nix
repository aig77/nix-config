{config, ...}: {
  configurations.nixos.jet.module = {inputs, ...}: {
    facter.reportPath = ./facter.json;
    imports =
      [inputs.nixos-facter-modules.nixosModules.facter]
      ++ (with config.flake.modules.nixos; [
        base
        server
        grub-server
        tailscale
        invidious
        n8n
        uptime-kuma
      ]);
    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
