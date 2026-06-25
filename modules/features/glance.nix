_: {
  flake.modules.nixos.glance = {
    config,
    lib,
    ...
  }: {
    var.services.glance = {
      subdomain = "glance";
      port = config.ports.glance;
      public = false;
      auth = false;
    };

    sops = {
      secrets = {
        "tailscale/tailnet" = {};
        "cloudflare/service-domain" = {};
      };
      templates."glance.env" = {
        content = ''
          TAILSCALE_HOST=${config.var.hostname}.${config.sops.placeholder."tailscale/tailnet"}
          SERVICE_DOMAIN=${config.sops.placeholder."cloudflare/service-domain"}
        '';
      };
    };

    services.glance = {
      enable = true;
      settings = {
        server = {
          port = config.ports.glance;
          host = "0.0.0.0";
        };
        pages = [
          {
            name = "Home";
            columns = [
              {
                size = "full";
                widgets = [
                  {
                    type = "bookmarks";
                    groups = [
                      {
                        title = "Private";
                        links = [
                          {
                            title = "Actual Budget";
                            description = "Personal finance manager";
                            url = "http://\${TAILSCALE_HOST}:${toString config.ports.actualBudget}";
                            icon = "si:actualbudget";
                          }
                          {
                            title = "Grafana";
                            description = "Metrics and dashboards";
                            url = "http://\${TAILSCALE_HOST}:${toString config.ports.grafana}";
                            icon = "si:grafana";
                          }
                          {
                            title = "Gatus";
                            description = "Service uptime monitor";
                            url = "http://\${TAILSCALE_HOST}:${toString config.ports.gatus}";
                            icon = "si:statuspage";
                          }
                          {
                            title = "n8n";
                            description = "Workflow automation";
                            url = "http://\${TAILSCALE_HOST}:${toString config.ports.n8n}";
                            icon = "si:n8n";
                          }
                        ];
                      }
                      {
                        title = "Public";
                        links = [
                          {
                            title = "Daily Stoic";
                            description = "Daily stoic quote delivery";
                            url = "https://stoic.\${SERVICE_DOMAIN}";
                            icon = "si:bookstack";
                          }
                          {
                            title = "Invidious";
                            description = "Privacy-friendly YouTube frontend";
                            url = "https://invidious.\${SERVICE_DOMAIN}";
                            icon = "si:youtube";
                          }
                          {
                            title = "Vaultwarden";
                            description = "Password manager";
                            url = "https://vault.\${SERVICE_DOMAIN}";
                            icon = "si:bitwarden";
                          }
                        ];
                      }
                    ];
                  }
                ];
              }
            ];
          }
        ];
      };
    };

    systemd.services.glance.serviceConfig.EnvironmentFile = lib.mkForce config.sops.templates."glance.env".path;

    networking.firewall.allowedTCPPorts = [config.ports.glance];
  };
}
