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
        caddy
        cloudflared
        gatus
        glance
        grafana
        invidious
        n8n
        prometheus
        daily-stoic
        vaultwarden
        actual-budget
        backup
      ]);
    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
