_: {
  flake.modules.nixos.n8n = {config, ...}: {
    var.services.n8n = {
      subdomain = "n8n";
      port = config.ports.n8n;
      public = false;
      auth = false;
    };

    sops.secrets."discord/daily-stoic-bot-token" = {};

    sops.templates."n8n.env" = {
      mode = "0444";
      content = ''
        DISCORD_TOKEN=${config.sops.placeholder."discord/daily-stoic-bot-token"}
      '';
    };

    services.n8n = {
      enable = true;
      environment = {
        GENERIC_TIMEZONE = "America/New_York";
        N8N_PORT = toString config.ports.n8n;
        N8N_SECURE_COOKIE = "false";
      };
    };

    networking.firewall.allowedTCPPorts = [config.ports.n8n];

    systemd.services.n8n.serviceConfig.EnvironmentFile =
      config.sops.templates."n8n.env".path;
  };
}
