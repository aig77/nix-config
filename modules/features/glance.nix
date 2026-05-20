_: {
  flake.modules.nixos.glance = {config, ...}: {
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
                        title = "Monitoring";
                        links = [
                          {
                            title = "Grafana";
                            url = "http://${config.var.ip}:${toString config.ports.grafana}";
                            icon = "si:grafana";
                          }
                          {
                            title = "Gatus";
                            url = "http://${config.var.ip}:${toString config.ports.gatus}";
                            icon = "si:statuspage";
                          }
                        ];
                      }
                      {
                        title = "Services";
                        links = [
                          {
                            title = "Invidious";
                            url = "https://invidious.${config.var.domain}";
                            icon = "si:youtube";
                          }
                          {
                            title = "n8n";
                            url = "http://${config.var.ip}:${toString config.ports.n8n}";
                            icon = "si:n8n";
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

    networking.firewall.allowedTCPPorts = [config.ports.glance];
  };
}
