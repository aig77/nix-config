_: {
  flake.modules.nixos.healthchecks = {
    config,
    pkgs,
    ...
  }: {
    sops.secrets."healthchecks/${config.var.hostname}/ping-url" = {};

    systemd = {
      services.healthchecks-ping = {
        description = "Healthchecks.io heartbeat";
        after = ["network.target"];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "hc-ping" ''
            ${pkgs.curl}/bin/curl -fsS -m 10 --retry 5 \
              "$(cat ${config.sops.secrets."healthchecks/${config.var.hostname}/ping-url".path})"
          '';
        };
      };

      timers.healthchecks-ping = {
        wantedBy = ["timers.target"];
        timerConfig = {
          OnBootSec = "5m";
          OnUnitActiveSec = "5m";
          Unit = "healthchecks-ping.service";
        };
      };
    };
  };
}
