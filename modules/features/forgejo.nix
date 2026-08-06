_: {
  flake.modules.nixos.forgejo = {
    config,
    pkgs,
    ...
  }: let
    subdomain = "git";
    domain = config.sops.placeholder."cloudflare/service-domain";
    stateDir = config.services.forgejo.stateDir;
    customDir = config.services.forgejo.customDir;
    configPath = "${customDir}/conf/app.ini";
    forgejo = config.services.forgejo.package;
  in {
    var.services.forgejo = {
      inherit subdomain;
      port = config.ports.forgejo;
      public = true;
      auth = false;
      backup = {
        paths = [
          "/var/lib/backups/forgejo.sql"
          "${stateDir}/repositories"
          "${stateDir}/data"
        ];
        prepareCommand = ''
          mkdir -p /var/lib/backups
          ${pkgs.util-linux}/bin/runuser -u postgres -- ${pkgs.postgresql}/bin/pg_dump ${config.services.forgejo.database.name} > /var/lib/backups/forgejo.sql
        '';
      };
    };

    sops = {
      secrets = {
        "cloudflare/service-domain" = {};
        "forgejo/bootstrap-admin-email" = {};
        "forgejo/smtp-password" = {};
      };

      templates."forgejo.env" = {
        mode = "0444";
        content = ''
          FORGEJO_ADMIN_EMAIL=${config.sops.placeholder."forgejo/bootstrap-admin-email"}
        '';
      };
    };

    services.forgejo = {
      enable = true;
      database.type = "postgres";
      lfs.enable = true;
      settings = {
        server = {
          DOMAIN = "${subdomain}.${domain}";
          ROOT_URL = "https://${subdomain}.${domain}/";
          HTTP_ADDR = "127.0.0.1";
          HTTP_PORT = config.ports.forgejo;
          DISABLE_SSH = true;
        };
        service = {
          REGISTER_EMAIL_CONFIRM = false;
          REGISTER_MANUAL_CONFIRM = true;
          ENABLE_NOTIFY_MAIL = true;
        };
        mailer = {
          ENABLED = true;
          PROTOCOL = "smtps";
          SMTP_ADDR = "smtp.resend.com";
          SMTP_PORT = 465;
          USER = "resend";
          FROM = "forgejo@resend.${domain}";
        };
        session.COOKIE_SECURE = true;
      };
      secrets.mailer.PASSWD = config.sops.secrets."forgejo/smtp-password".path;
    };

    systemd.services.forgejo-admin = {
      description = "Forgejo admin user bootstrap";
      after = ["forgejo.service"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        User = config.services.forgejo.user;
        Group = config.services.forgejo.group;
        EnvironmentFile = config.sops.templates."forgejo.env".path;
        Environment = [
          "USER=${config.services.forgejo.user}"
          "HOME=${stateDir}"
          "FORGEJO_WORK_DIR=${stateDir}"
          "FORGEJO_CUSTOM=${customDir}"
        ];
      };
      script = ''
        if ! ${forgejo}/bin/forgejo admin user list --config ${configPath} | ${pkgs.gnugrep}/bin/grep -qw ${config.var.username}; then
          ${forgejo}/bin/forgejo admin user create \
            --config ${configPath} \
            --username ${config.var.username} \
            --email "$FORGEJO_ADMIN_EMAIL" \
            --admin \
            --random-password \
            --must-change-password
        fi
      '';
    };
  };
}
