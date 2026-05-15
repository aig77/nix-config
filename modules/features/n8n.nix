_: {
  flake.modules.nixos.n8n = {config, ...}: {
    sops.secrets.discord-token = {};

    sops.templates."n8n.env" = {
      mode = "0444";
      content = ''
        DISCORD_TOKEN=${config.sops.placeholder."discord-token"}
      '';
    };

    services.n8n = {
      enable = true;
      environment = {
        GENERIC_TIMEZONE = "America/New_York";
        N8N_PORT = "5678";
        N8N_SECURE_COOKIE = "false";
      };
    };

    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [5678];

    systemd.services.n8n.serviceConfig.EnvironmentFile =
      config.sops.templates."n8n.env".path;
  };
}
