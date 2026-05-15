{config, ...}: {
  configurations.nixos.jet.module = {inputs, ...}: {
    imports =
      [inputs.nixos-facter-modules.nixosModules.facter ./facter.json]
      ++ (with config.flake.modules.nixos; [
        base
        server
        grub-server
        tailscale
        invidious
        n8n
      ]);
    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
