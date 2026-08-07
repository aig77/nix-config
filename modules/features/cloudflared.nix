_: {
  flake.modules.nixos.cloudflared = {
    config,
    lib,
    pkgs,
    ...
  }: let
    publicServices = lib.filter (s: s.public) (lib.attrValues config.var.services);
    domain = config.sops.placeholder."cloudflare/service-domain";
    ingressRules =
      lib.concatMapStrings (svc: ''
        - hostname: ${svc.subdomain}.${domain}
          service: https://localhost
          originRequest:
            noTLSVerify: true
            originServerName: ${svc.subdomain}.${domain}
      '')
      publicServices;
  in {
    users.users.cloudflared = {
      isSystemUser = true;
      group = "cloudflared";
    };
    users.groups.cloudflared = {};

    sops = {
      secrets = {
        "cloudflare/tunnel-id" = {};
        "cloudflare/tunnel-credentials" = {
          mode = "0400";
          owner = "cloudflared";
        };
      };
      templates."cloudflared.yml" = {
        owner = "cloudflared";
        restartUnits = ["cloudflared.service"];
        content = ''
          tunnel: ${config.sops.placeholder."cloudflare/tunnel-id"}
          credentials-file: ${config.sops.secrets."cloudflare/tunnel-credentials".path}
          ingress:
          ${ingressRules}- service: http_status:404
        '';
      };
    };

    systemd.services.cloudflared = {
      description = "Cloudflare Tunnel";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --config=${config.sops.templates."cloudflared.yml".path} --no-autoupdate run";
        User = "cloudflared";
        Group = "cloudflared";
        Restart = "on-failure";
      };
    };
  };
}
