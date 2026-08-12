_: {
  flake.modules = {
    nixos = {
      tailscale = {
        services.tailscale.enable = true;
      };

      tailscale-router = {config, ...}: {
        sops.secrets."tailscale/authkey" = {};

        services.tailscale = {
          enable = true;
          useRoutingFeatures = "server";
          authKeyFile = config.sops.secrets."tailscale/authkey".path;
          extraUpFlags = ["--advertise-routes=192.168.68.0/24" "--reset"];
          openFirewall = true;
        };
      };

      # Server only: serve non-public services over the tailnet with HTTPS
      tailscale-http = {
        config,
        lib,
        pkgs,
        ...
      }: let
        privateServices = lib.filter (s: !s.public) (lib.attrValues config.var.services);
        tailscale = lib.getExe pkgs.tailscale;
      in {
        services.tailscale.enable = true;

        systemd.services.tailscale-https = lib.mkIf (privateServices != []) {
          description = "Tailscale HTTPS serve for private services";
          after = ["tailscaled.service" "tailscaled-autoconnect.service"];
          wants = ["tailscaled.service"];
          wantedBy = ["multi-user.target"];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart =
              lib.optional (config.var.services ? glance) "${tailscale} serve --bg --https=443 http://localhost:${toString config.ports.glance}"
              ++ map (svc: "${tailscale} serve --bg --https=${toString svc.port} http://localhost:${toString svc.port}") privateServices;
            ExecStop = "${tailscale} serve reset";
          };
        };
      };
    };

    darwin.tailscale = {
      services.tailscale.enable = true;
    };
  };
}
