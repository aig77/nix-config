_: {
  flake.modules.nixos.tailscale = {
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
}
