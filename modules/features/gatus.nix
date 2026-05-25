_: {
  flake.modules.nixos.gatus = {config, ...}: {
    sops = {
      secrets.gatus-discord-webhook = {};
      templates."gatus.env" = {
        content = ''
          DISCORD_WEBHOOK=${config.sops.placeholder."gatus-discord-webhook"}
        '';
      };
    };

    services.gatus = {
      enable = true;
      openFirewall = true;
      environmentFile = config.sops.templates."gatus.env".path;
      settings = {
        web.port = config.ports.gatus;

        storage = {
          type = "sqlite";
          path = "/var/lib/gatus/data.db";
        };

        alerting.discord.webhook-url = "\${DISCORD_WEBHOOK}";

        endpoints = [
          {
            name = "Invidious";
            group = "Invidious";
            url = "http://localhost:${toString config.ports.invidious}/api/v1/stats";
            interval = "5m";
            conditions = ["[STATUS] == 200"];
            alerts = [
              {
                type = "discord";
                failure-threshold = 2;
                success-threshold = 1;
              }
            ];
          }
          {
            name = "Companion";
            group = "Invidious";
            url = "tcp://localhost:${toString config.ports.invidiousCompanion}";
            interval = "5m";
            conditions = ["[CONNECTED] == true"];
            alerts = [
              {
                type = "discord";
                failure-threshold = 2;
                success-threshold = 1;
              }
            ];
          }
          {
            name = "Grafana";
            url = "http://localhost:${toString config.ports.grafana}/api/health";
            interval = "5m";
            conditions = ["[STATUS] == 200"];
            alerts = [
              {
                type = "discord";
                failure-threshold = 2;
                success-threshold = 1;
              }
            ];
          }
          {
            name = "n8n";
            url = "http://localhost:${toString config.ports.n8n}/healthz";
            interval = "5m";
            conditions = ["[STATUS] == 200"];
            alerts = [
              {
                type = "discord";
                failure-threshold = 2;
                success-threshold = 1;
              }
            ];
          }
          {
            name = "Blocky DNS";
            url = "tcp://192.168.68.101:53";
            interval = "1m";
            conditions = ["[CONNECTED] == true"];
            alerts = [
              {
                type = "discord";
                failure-threshold = 2;
                success-threshold = 1;
              }
            ];
          }
        ];
      };
    };
  };
}
