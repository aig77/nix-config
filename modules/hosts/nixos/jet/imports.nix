{config, ...}: {
  configurations.nixos.jet.module = {
    # After running nixos-anywhere, commit facter.json and add it here:
    # imports = [inputs.nixos-facter-modules.nixosModules.facter ./facter.json];
    imports = with config.flake.modules.nixos; [
      base
      server
      tailscale
      invidious
      n8n
      caddy
    ];
    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
