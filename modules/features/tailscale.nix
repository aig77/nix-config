_: {
  flake.modules = {
    nixos = {
      tailscale = {
        services.tailscale = {
          enable = true;
          extraSetFlags = ["--accept-routes"];
        };
      };

      tailscale-router = {config, ...}: {
        sops.secrets."tailscale/authkey" = {};

        services.tailscale = {
          enable = true;
          useRoutingFeatures = "server";
          authKeyFile = config.sops.secrets."tailscale/authkey".path;
          extraUpFlags = ["--advertise-routes=${config.var.network.subnet}" "--reset"];
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
        httpsPort = svc:
          if svc.servePort != null
          then svc.servePort
          else svc.port;
        serveCmd = svc: "${tailscale} serve --bg --https=${toString (httpsPort svc)} http://localhost:${toString svc.port}";
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
            Restart = "on-failure";
            RestartSec = "5s";
            ExecStart = map serveCmd privateServices;
            ExecStop = "${tailscale} serve reset";
          };
        };

        assertions = [
          {
            assertion =
              lib.unique (map httpsPort privateServices) == map httpsPort privateServices;
            message = "Tailscale serve HTTPS ports must be unique across private services: ${toString (map httpsPort privateServices)}";
          }
        ];
      };
    };

    darwin.tailscale = {
      services.tailscale.enable = true;
    };
  };
}
