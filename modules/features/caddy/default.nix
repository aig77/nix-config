# The Cloudflare DNS plugin version and hash must be filled in before deploying.
# To find them:
#   nix shell nixpkgs#xcaddy
#   xcaddy build --with github.com/caddy-dns/cloudflare
# Then use the version from go.sum and compute the hash:
#   nix run nixpkgs#nix-prefetch-github -- caddy-dns cloudflare
#
# Or check: https://github.com/caddy-dns/cloudflare/releases
{lib, ...}: {
  flake.modules.nixos.caddy = {
    config,
    pkgs,
    ...
  }: {
    sops.secrets.caddy-cloudflare-env = {};

    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = [
          # Replace <version> with the actual module version tag, e.g.:
          # "github.com/caddy-dns/cloudflare@v0.0.0-20250111044524-c07fada72a9a"
          "github.com/caddy-dns/cloudflare@<version>"
        ];
        # Replace with: nix hash to-sri --type sha256 $(nix-prefetch-url --unpack <tarball>)
        hash = lib.fakeHash;
      };
      globalConfig = ''
        acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      '';
      virtualHosts = {
        "invidious.yourdomain.com" = {
          extraConfig = "reverse_proxy localhost:3000";
        };
        "n8n.yourdomain.com" = {
          extraConfig = "reverse_proxy localhost:5678";
        };
      };
    };

    systemd.services.caddy.serviceConfig.EnvironmentFile =
      config.sops.secrets.caddy-cloudflare-env.path;

    networking.firewall.allowedTCPPorts = [80 443];
  };
}
