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

        backup

        actual-budget
        daily-stoic
        gatus
        glance
        grafana
        invidious
        n8n
        open-webui
        prometheus
        subtrakr
        vaultwarden
      ]);
    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
