_: {
  flake.modules.nixos.daily-stoic = {config, inputs, ...}: {
    imports = [inputs.daily-stoic.nixosModules.default];

    var.services.daily-stoic = {
      subdomain = "stoic";
      port = config.ports.dailyStoic;
      public = true;
      auth = false;
    };

    sops.secrets."daily-stoic/api-key" = {};
    sops.secrets."daily-stoic/resend/api-key" = {};
    sops.secrets."daily-stoic/resend/email" = {};
    sops.secrets."daily-stoic/bootstrap-admin-email" = {};
    sops.secrets."cloudflare/service-domain" = {};

    sops.templates."daily-stoic.env" = {
      mode = "0444";
      content = ''
        API_KEY=${config.sops.placeholder."daily-stoic/api-key"}
        RESEND_API_KEY=${config.sops.placeholder."daily-stoic/resend/api-key"}
        RESEND_EMAIL=${config.sops.placeholder."daily-stoic/resend/email"}
        BASE_URL=https://stoic.${config.sops.placeholder."cloudflare/service-domain"}
        BOOTSTRAP_ADMIN_EMAIL=${config.sops.placeholder."daily-stoic/bootstrap-admin-email"}
      '';
    };

    services.daily-stoic = {
      enable = true;
      port = config.ports.dailyStoic;
      environmentFile = config.sops.templates."daily-stoic.env".path;
    };
  };
}
