_: {
  flake.modules.nixos.searx = {config, ...}: {
    var.services.searx = {
      subdomain = "search";
      port = config.ports.searx;
      public = false;
      auth = false;
    };

    sops = {
      secrets."searx/secret-key" = {};

      templates."searx-env" = {
        mode = "0444";
        content = ''
          SEARX_SECRET_KEY=${config.sops.placeholder."searx/secret-key"}
        '';
      };
    };

    services.searx = {
      enable = true;
      redisCreateLocally = true;
      environmentFile = config.sops.templates."searx-env".path;
      settings = {
        server = {
          secret_key = "$SEARX_SECRET_KEY";
          port = config.ports.searx;
          bind_address = "0.0.0.0";
          limiter = false;
        };
      };
    };
  };
}
