_: {
  flake.modules.nixos.vaultwarden = {
    config,
    pkgs,
    ...
  }: {
    var.services.vaultwarden = {
      subdomain = "vault";
      port = config.ports.vaultwarden;
      public = true;
      auth = false;
      backup = {
        paths = ["/var/lib/backups/vaultwarden"];
        prepareCommand = ''
          mkdir -p /var/lib/backups/vaultwarden
          ${pkgs.sqlite}/bin/sqlite3 /var/lib/bitwarden_rs/db.sqlite3 \
            ".backup '/var/lib/backups/vaultwarden/db.sqlite3'"
          cp -r /var/lib/bitwarden_rs/attachments \
            /var/lib/backups/vaultwarden/ 2>/dev/null || true
        '';
      };
    };

    sops = {
      secrets = {
        "vaultwarden/admin-token" = {};
        "cloudflare/service-domain" = {};
      };
      templates."vaultwarden.env" = {
        mode = "0400";
        content = ''
          ADMIN_TOKEN=${config.sops.placeholder."vaultwarden/admin-token"}
          DOMAIN=https://vault.${config.sops.placeholder."cloudflare/service-domain"}
        '';
      };
    };

    services.vaultwarden = {
      enable = true;
      environmentFile = config.sops.templates."vaultwarden.env".path;
      config = {
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = config.ports.vaultwarden;
        SIGNUPS_ALLOWED = false;
        SHOW_PASSWORD_HINT = false;
        LOG_LEVEL = "warn";
      };
    };
  };
}
