_: {
  flake.modules.nixos.gatus = {config, ...}: {
    var.services.gatus = {
      subdomain = "gatus";
      port = config.ports.gatus;
      public = false;
      auth = false;
    };

    users.users.gatus = {
      isSystemUser = true;
      group = "gatus";
    };
    users.groups.gatus = {};

    sops = {
      secrets = {
        "discord/ein-webhook" = {};
        "tailscale/tailnet" = {};
      };
      templates."gatus.env" = {
        owner = "gatus";
        content = ''
          DISCORD_WEBHOOK_URL=${config.sops.placeholder."discord/ein-webhook"}
          TAILNET=${config.sops.placeholder."tailscale/tailnet"}
        '';
      };
    };

    services.gatus = {
      enable = true;
      environmentFile = config.sops.templates."gatus.env".path;
      settings = {
        web = {
          address = "127.0.0.1";
          port = config.ports.gatus;
        };
        storage = {
          type = "sqlite";
          path = "/var/lib/gatus/data.db";
        };
        ui = {
          title = "Bebop Health Dashboard";
          "login-subtitle" = null;
          header = "Bebop";
          "dashboard-heading" = "Is the ship running?";
          "dashboard-subheading" = null;
          logo = "https://www.clipartmax.com/png/full/132-1326331_zoom-edward-cowboy-bebop-png.png";
          link = "https://github.com/aig77/bebop";
          favicon.default = "https://www.vhv.rs/viewpic/hoobhxi_swordfish-png-cowboy-bebop-transparent-png/#";
          buttons = [
            {
              name = "Home";
              link = "https://${config.var.hostname}.\${TAILNET}";
            }
            {
              name = "GitHub";
              link = "https://github.com/aig77/bebop";
            }
          ];
          "custom-css" = ''
            /* Catppuccin Mocha */
            :root:root, :root:root.dark {
              --background: 240 21% 15%;
              --foreground: 226 64% 88%;
              --card: 237 16% 23%;
              --card-foreground: 226 64% 88%;
              --popover: 237 16% 23%;
              --popover-foreground: 226 64% 88%;
              --primary: 217 92% 76%;
              --primary-foreground: 240 21% 15%;
              --secondary: 235 13% 31%;
              --secondary-foreground: 226 64% 88%;
              --muted: 235 13% 31%;
              --muted-foreground: 230 13% 56%;
              --accent: 268 84% 81%;
              --accent-foreground: 240 21% 15%;
              --destructive: 343 81% 75%;
              --destructive-foreground: 240 21% 15%;
              --border: 237 16% 23%;
              --input: 237 16% 23%;
              --ring: 217 92% 76%;
            }
            .bg-success { background-color: #a6e3a1 !important; }
          '';
        };
        alerting.discord."webhook-url" = "\${DISCORD_WEBHOOK_URL}";
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
                "failure-threshold" = 2;
                "success-threshold" = 1;
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
                "failure-threshold" = 2;
                "success-threshold" = 1;
              }
            ];
          }
          {
            name = "YouTube API";
            group = "Invidious";
            url = "http://localhost:${toString config.ports.invidious}/api/v1/trending";
            interval = "15m";
            conditions = ["[STATUS] == 200" "[BODY] != []"];
            alerts = [
              {
                type = "discord";
                "failure-threshold" = 1;
                "success-threshold" = 1;
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
                "failure-threshold" = 2;
                "success-threshold" = 1;
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
                "failure-threshold" = 2;
                "success-threshold" = 1;
              }
            ];
          }
          {
            name = "Vaultwarden";
            url = "tcp://localhost:${toString config.ports.vaultwarden}";
            interval = "1m";
            conditions = ["[CONNECTED] == true"];
            alerts = [
              {
                type = "discord";
                "failure-threshold" = 1;
                "success-threshold" = 1;
              }
            ];
          }
          {
            name = "Daily Stoic";
            url = "http://localhost:${toString config.ports.dailyStoic}/health";
            interval = "5m";
            conditions = ["[STATUS] == 200"];
            alerts = [
              {
                type = "discord";
                "failure-threshold" = 2;
                "success-threshold" = 1;
              }
            ];
          }
          {
            name = "Actual Budget";
            url = "http://localhost:${toString config.ports.actualBudget}/";
            interval = "5m";
            conditions = ["[STATUS] == 200"];
            alerts = [
              {
                type = "discord";
                "failure-threshold" = 2;
                "success-threshold" = 1;
              }
            ];
          }
          {
            name = "Subtrakr";
            url = "http://localhost:${toString config.ports.subtrakr}/healthz";
            interval = "5m";
            conditions = ["[STATUS] == 200" "[BODY].status == healthy"];
            alerts = [
              {
                type = "discord";
                "failure-threshold" = 2;
                "success-threshold" = 1;
              }
            ];
          }
          {
            name = "Open WebUI";
            url = "http://localhost:${toString config.ports.open-webui}/health";
            interval = "5m";
            conditions = ["[STATUS] == 200" "[BODY].status == true"];
            alerts = [
              {
                type = "discord";
                "failure-threshold" = 2;
                "success-threshold" = 1;
              }
            ];
          }
          {
            name = "SearXNG";
            url = "http://localhost:${toString config.ports.searx}/healthz";
            interval = "5m";
            conditions = ["[STATUS] == 200" "[BODY] == OK"];
            alerts = [
              {
                type = "discord";
                "failure-threshold" = 2;
                "success-threshold" = 1;
              }
            ];
          }
          {
            name = "Forgejo";
            url = "http://localhost:${toString config.ports.forgejo}/api/healthz";
            interval = "5m";
            conditions = ["[STATUS] == 200" "[BODY].status == pass"];
            alerts = [
              {
                type = "discord";
                "failure-threshold" = 2;
                "success-threshold" = 1;
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
                "failure-threshold" = 2;
                "success-threshold" = 1;
              }
            ];
          }
        ];
      };
    };
  };
}
