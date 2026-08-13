_: {
  flake.modules.nixos.prometheus = {config, ...}: let
    edIp = config.var.network.hosts.ed;
  in {
    var.services.prometheus = {
      subdomain = "prometheus";
      port = config.ports.prometheus;
      public = false;
      auth = false;
    };

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
            {targets = ["127.0.0.1:${toString config.ports.nodeExporter}" "${edIp}:${toString config.ports.nodeExporter}"];}
          ];
        }
        {
          job_name = "blocky";
          static_configs = [{targets = ["${edIp}:${toString config.ports.blockyHttp}"];}];
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
