{config, ...}: {
  configurations.nixos.jet.module = {inputs, ...}: {
    facter.reportPath = ./facter.json;
    imports =
      [inputs.nixos-facter-modules.nixosModules.facter]
      ++ (with config.flake.modules.nixos; [
        base
        server
        grub-server

        backup
        caddy
        cloudflared
        tailscale-http

        actual-budget
        daily-stoic
        gatus
        glance
        grafana
        # invidious # temporarily remove since its down. plan on updating module with docker setup
        n8n
        open-webui
        prometheus
        subtrakr
        vaultwarden
      ]);
    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
