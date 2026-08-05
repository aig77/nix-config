{inputs, ...}: {
  flake.modules.nixos.gatus = {
    config,
    pkgs,
    ...
  }: let
    # TODO: remove this override once nixpkgs gatus >= 5.36.0 (custom-css support)
    # When that lands, delete this let block and switch ExecStart back to ${pkgs.gatus}/bin/gatus.
    gatus = pkgs.buildGoModule {
      pname = "gatus";
      version = "master";
      src = inputs.gatus;
      vendorHash = "sha256-RbFNtojZthf7bKMhGStH/jOkeIR6EHpw2vvAMLEFtKI=";
      subPackages = ["."];
    };
  in {
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
      templates."gatus.yaml" = {
        owner = "gatus";
        content = ''
          web:
            address: 127.0.0.1
            port: ${toString config.ports.gatus}
          storage:
            type: sqlite
            path: /var/lib/gatus/data.db
          ui:
            title: Bebop Health Dashboard
            login-subtitle:
            header: Bebop
            dashboard-heading: Is the ship running?
            dashboard-subheading:
            logo: https://www.clipartmax.com/png/full/132-1326331_zoom-edward-cowboy-bebop-png.png
            link: https://github.com/aig77/bebop
            favicon:
              default: https://www.vhv.rs/viewpic/hoobhxi_swordfish-png-cowboy-bebop-transparent-png/#
            buttons:
              - name: Home
                link: https://${config.var.hostname}.${config.sops.placeholder."tailscale/tailnet"}
              - name: GitHub
                link: https://github.com/aig77/bebop
            custom-css: |
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
          alerting:
            discord:
              webhook-url: ${config.sops.placeholder."discord/ein-webhook"}
          endpoints:
            - name: Invidious
              group: Invidious
              url: http://localhost:${toString config.ports.invidious}/api/v1/stats
              interval: 5m
              conditions:
                - "[STATUS] == 200"
              alerts:
                - type: discord
                  failure-threshold: 2
                  success-threshold: 1
            - name: Companion
              group: Invidious
              url: tcp://localhost:${toString config.ports.invidiousCompanion}
              interval: 5m
              conditions:
                - "[CONNECTED] == true"
              alerts:
                - type: discord
                  failure-threshold: 2
                  success-threshold: 1
            - name: YouTube API
              group: Invidious
              url: http://localhost:${toString config.ports.invidious}/api/v1/trending
              interval: 15m
              conditions:
                - "[STATUS] == 200"
                - "[BODY] != []"
              alerts:
                - type: discord
                  failure-threshold: 1
                  success-threshold: 1
            - name: PostgreSQL
              group: Invidious
              url: tcp://localhost:5432
              interval: 1m
              conditions:
                - "[CONNECTED] == true"
              alerts:
                - type: discord
                  failure-threshold: 1
                  success-threshold: 1
            - name: Grafana
              url: http://localhost:${toString config.ports.grafana}/api/health
              interval: 5m
              conditions:
                - "[STATUS] == 200"
              alerts:
                - type: discord
                  failure-threshold: 2
                  success-threshold: 1
            - name: n8n
              url: http://localhost:${toString config.ports.n8n}/healthz
              interval: 5m
              conditions:
                - "[STATUS] == 200"
              alerts:
                - type: discord
                  failure-threshold: 2
                  success-threshold: 1
            - name: Vaultwarden
              url: tcp://localhost:${toString config.ports.vaultwarden}
              interval: 1m
              conditions:
                - "[CONNECTED] == true"
              alerts:
                - type: discord
                  failure-threshold: 1
                  success-threshold: 1
            - name: Daily Stoic
              url: http://localhost:${toString config.ports.dailyStoic}/health
              interval: 5m
              conditions:
                - "[STATUS] == 200"
              alerts:
                - type: discord
                  failure-threshold: 2
                  success-threshold: 1
            - name: Actual Budget
              url: http://localhost:${toString config.ports.actualBudget}/
              interval: 5m
              conditions:
                - "[STATUS] == 200"
              alerts:
                - type: discord
                  failure-threshold: 2
                  success-threshold: 1
            - name: Subtrakr
              url: http://localhost:${toString config.ports.subtrakr}/healthz
              interval: 5m
              conditions:
                - "[STATUS] == 200"
                - "[BODY].status == healthy"
              alerts:
                - type: discord
                  failure-threshold: 2
                  success-threshold: 1
            - name: Open WebUI
              url: http://localhost:${toString config.ports.open-webui}/health
              interval: 5m
              conditions:
                - "[STATUS] == 200"
                - "[BODY].status == true"
              alerts:
                - type: discord
                  failure-threshold: 2
                  success-threshold: 1
            - name: SearX
              url: http://localhost:${toString config.ports.searx}/healthz
              interval: 5m
              conditions:
                - "[STATUS] == 200"
                - "[BODY].status == true"
              alerts:
                - type: discord
                  failure-threshold: 2
                  success-threshold: 1
            - name: Blocky DNS
              url: tcp://192.168.68.101:53
              interval: 1m
              conditions:
                - "[CONNECTED] == true"
              alerts:
                - type: discord
                  failure-threshold: 2
                  success-threshold: 1
        '';
      };
    };

    systemd.services.gatus = {
      description = "Gatus health monitoring";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStart = "${gatus}/bin/gatus";
        Environment = "GATUS_CONFIG_PATH=${config.sops.templates."gatus.yaml".path}";
        User = "gatus";
        Group = "gatus";
        StateDirectory = "gatus";
        Restart = "on-failure";
      };
    };
  };
}
