_: {
  flake.modules.nixos.caddy = {
    config,
    pkgs,
    ...
  }: {
    sops = {
      secrets.caddy-cloudflare-token = {};
      secrets.invidious-basic-auth-hash = {};
      templates."caddy.env" = {
        mode = "0400";
        owner = "caddy";
        content = ''
          CLOUDFLARE_API_TOKEN=${config.sops.placeholder."caddy-cloudflare-token"}
        '';
      };
      # Caddyfile snippet imported by the invidious vhost. Using a template
      # embeds the raw bcrypt hash directly into Caddyfile syntax, avoiding
      # the base64 encoding required by Caddy's JSON/env-var path.
      templates."caddy-invidious-auth" = {
        mode = "0400";
        owner = "caddy";
        content = ''
          basic_auth * {
            arepa ${config.sops.placeholder."invidious-basic-auth-hash"}
          }
        '';
      };
    };

    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = [
          # To update: nix run nixpkgs#nix-prefetch-github -- caddy-dns cloudflare
          # Then get the version: nix shell nixpkgs#go --command go list -m github.com/caddy-dns/cloudflare@<rev>
          "github.com/caddy-dns/cloudflare@v0.2.4"
        ];
        # Hash is for the combined caddy+plugin source. To update: set hash = lib.fakeHash,
        # build, and copy the "got:" value from the hash mismatch error.
        hash = "sha256-Olz4W84Kiyldy+JtbIicVCL7dAYl4zq+2rxEOUTObxA=";
      };
      globalConfig = ''
        acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      '';
      virtualHosts."invidious.${config.var.domain}" = {
        extraConfig = ''
          @authapi path /api/v1/auth/*
          handle @authapi {
            reverse_proxy localhost:3000 {
              header_up -X-Forwarded-For
            }
          }
          handle {
            import ${config.sops.templates."caddy-invidious-auth".path}
            reverse_proxy localhost:3000 {
              header_up -X-Forwarded-For
            }
          }
        '';
      };
    };

    systemd.services.caddy.serviceConfig.EnvironmentFile =
      config.sops.templates."caddy.env".path;

    networking.firewall.allowedTCPPorts = [80 443];
  };
}
