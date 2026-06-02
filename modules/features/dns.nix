_: {
  flake.modules.nixos.dns = {config, ...}: {
    services = {
      blocky = {
        enable = true;
        settings = {
          ports = {
            dns = 53;
            http = config.ports.blockyHttp;
          };

          upstreams.groups.default = [
            "https://one.one.one.one/dns-query"
          ];

          bootstrapDns = {
            upstream = "https://one.one.one.one/dns-query";
            ips = ["1.1.1.1" "1.0.0.1"];
          };

          blocking = {
            denylists = {
              ads = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
            };
            clientGroupsBlock = {
              default = ["ads"];
            };
          };

          prometheus = {
            enable = true;
            path = "/metrics";
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
    };

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        53
        config.ports.blockyHttp
      ];
      allowedUDPPorts = [
        53
      ];
    };
  };
}
