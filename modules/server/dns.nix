{config, ...}: {
  services = {
    blocky = {
      enable = true;
      settings = {
        ports = {
          dns = 53;
          http = 4000; # Metrics
        };
        upstream.default = ["127.0.0.1:5335"];
        blocking = {
          denylists.ads = [
            "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt"
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
          ];
          clientGroupsBlock.default = ["ads"];
        };
        customDNS.mapping = {
          # "example.local" = "192.168.1.100"
        };
      };
    };

    unbound = {
      enable = true;
      settings.server = {
        port = 5335;
        interface = "127.0.0.1";
        access-control = [
          "127.0.0.1 allow"
          "::1 allow"
        ];
        do-ip4 = true;
        do-ip6 = true;
        prefer-ip6 = false;
        harden-glue = true;
        harden-dnssec-stripped = true;
        use-caps-for-id = false;
        edns-buffer-size = 1232;
        prefetch = true;
        prefetch-key = true;
      };
      settings.remote-control.control-enable = false;
    };

    prometheus = {
      enable = true;
      port = 9090;
      scrapeConfigs = [
        {
          job_name = "prometheus";
          static_configs = [{targets = ["127.0.0.1:9090"];}];
        }
        {
          job_name = "node";
          static_configs = [{targets = ["127.0.0.1:9100"];}];
        }
        {
          job_name = "blocky";
          static_configs = [{targets = ["127.0.0.1:4000"];}];
        }
      ];
      exporters.node = {
        enable = true;
        port = 9100;
      };
      retentionTime = "7d";
    };

    grafana = {
      enable = true;
      settings = {
        server.http_port = 3000;
        security.admin_password_path = "${config.sops.secrets.grafana-admin-password.path}";
      };
    };
  };
}
