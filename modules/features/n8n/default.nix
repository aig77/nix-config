_: {
  flake.modules.nixos.n8n = {config, ...}: {
    sops.secrets.n8n-discord-token-env = {};

    services.n8n = {
      enable = true;
      environment = {
        GENERIC_TIMEZONE = "America/New_York";
        N8N_PORT = "5678";
        N8N_SECURE_COOKIE = "false";
      };
    };

    systemd.services.n8n.serviceConfig.EnvironmentFile =
      config.sops.secrets.n8n-discord-token-env.path;
  };
}
