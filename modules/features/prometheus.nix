_: {
  flake.modules.nixos.prometheus = {config, ...}: {
    services.prometheus = {
      enable = true;
      port = config.ports.prometheus;
      retentionTime = "7d";
      exporters.node = {
        enable = true;
        port = config.ports.nodeExporter;
      };
      scrapeConfigs = [
        {
          job_name = "prometheus";
          static_configs = [{targets = ["127.0.0.1:${toString config.ports.prometheus}"];}];
        }
        {
          job_name = "node";
          static_configs = [
            {targets = ["127.0.0.1:${toString config.ports.nodeExporter}" "192.168.68.101:${toString config.ports.nodeExporter}"];}
          ];
        }
        {
          job_name = "blocky";
          static_configs = [{targets = ["192.168.68.101:${toString config.ports.blockyHttp}"];}];
        }
      ];
    };
  };

  flake.modules.nixos.prometheus-client = {config, ...}: {
    services.prometheus.exporters.node = {
      enable = true;
      port = config.ports.nodeExporter;
    };
    networking.firewall.allowedTCPPorts = [config.ports.nodeExporter];
  };
}
