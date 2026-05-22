# Server Modules

Feature modules for self-hosted services.

## Contents

- [Invidious](#invidious)
- [Caddy](#caddy)
- [DNS](#dns)
- [Auth Flow](#auth-flow)

---

## Invidious

**Profile:** `nixos.invidious`
**File:** `modules/features/invidious.nix`

YouTube frontend running on port 3000 (localhost only). Caddy proxies it externally.

The `invidious` and `invidious-companion` packages are built from flake inputs tracking
upstream master rather than nixpkgs, so they pick up fixes quickly without waiting for
a nixpkgs channel bump. A daily systemd timer (`invidious-update`) runs `nixos-rebuild switch`
at 04:00 from the GitHub flake, picking up any updated inputs committed from the workstation.

### invidious-companion

Companion handles PO token acquisition, which routes around YouTube's bot detection for
video playback. It is a pre-built binary from the `invidious-companion` flake input; `autoPatchelfHook`
rewrites its ELF interpreter so it runs on NixOS. `programs.nix-ld.enable = true` satisfies
dynamic linking for any libraries it loads at runtime.

### Secrets

| Secret | Purpose |
|--------|---------|
| `invidious-companion-key` | Shared HMAC key between invidious and companion, injected via sops template |

The companion key appears in two rendered sops templates:
- `invidious-companion-settings.json` - loaded by invidious as `extraSettingsFile`, tells invidious
  where companion lives and the shared key
- `invidious-companion.env` - loaded by the companion systemd unit as `SERVER_SECRET_KEY`

### Reference

- [Invidious source](https://github.com/iv-org/invidious)
- [invidious-companion source](https://github.com/iv-org/invidious-companion)
- [Invidious configuration options](https://docs.invidious.io/configuration/)

---

## Caddy

**Profile:** `nixos.caddy`
**File:** `modules/features/caddy.nix`

Reverse proxy handling TLS and access control for all public services. Uses the Cloudflare DNS
plugin to complete ACME DNS-01 challenges, which works even with Cloudflare proxying enabled
(orange cloud).

### Cloudflare DNS plugin

The plugin is pinned by version and a combined source hash:

```nix
package = pkgs.caddy.withPlugins {
  plugins = ["github.com/caddy-dns/cloudflare@v0.2.4"];
  hash = "sha256-Olz4W84Kiyldy+JtbIicVCL7dAYl4zq+2rxEOUTObxA=";
};
```

To update the plugin:
1. Get the latest revision: `nix run nixpkgs#nix-prefetch-github -- caddy-dns cloudflare`
2. Get the Go module version: `nix shell nixpkgs#go --command go list -m github.com/caddy-dns/cloudflare@<rev>`
3. Set `hash = lib.fakeHash`, build, copy the "got:" value from the mismatch error

### Basic auth

The invidious vhost is protected by HTTP Basic Auth. Caddy's `basic_auth` directive requires
bcrypt-hashed passwords. The hash is stored as a sops secret (`invidious-basic-auth-hash`)
and rendered into a Caddyfile snippet via sops template:

```
basic_auth * {
  arepa <bcrypt-hash>
}
```

The snippet is loaded with Caddy's `import` directive. This avoids the base64 encoding
that Caddy's JSON config path requires. The Caddyfile path accepts the raw `$2a$...` hash.

### Updating the password

1. Generate a new bcrypt hash (caddy need not be installed):
   ```bash
   nix shell nixpkgs#caddy --command caddy hash-password
   ```
2. Update the hash in sops:
   ```bash
   sops modules/aspects/secrets/secrets.yaml
   ```
   Replace the value of `invidious-basic-auth-hash` with the new `$2a$...` hash.
3. Deploy: `sudo nixos-rebuild switch --flake .#jet`
4. Update your password manager with the new password.

### Auth routing for API clients

Caddy's `basic_auth` consumes the `Authorization` header. Invidious API clients (like Yattee)
send their session token in the same header, so it never reaches invidious.

The fix: bypass basic auth for `/api/v1/auth/*` routes, which carry the session token.
Invidious's own auth protects those endpoints (a valid session token is still required).
All other routes (UI, public API) still require basic auth.

```
@authapi path /api/v1/auth/*
handle @authapi {
  reverse_proxy localhost:3000 { header_up -X-Forwarded-For }
}
handle {
  import <caddy-invidious-auth snippet>
  reverse_proxy localhost:3000 { header_up -X-Forwarded-For }
}
```

See [Yattee HTTP basic auth wiki](https://github.com/yattee/yattee/wiki/HTTP-basic-access-authentication)
for the recommended approach (nginx example, same principle applies to Caddy).
See [Yattee setup guide](../services/yattee.md) for connecting a client to this instance.

### Secrets

| Secret | Purpose |
|--------|---------|
| `caddy-cloudflare-token` | Cloudflare API token for DNS-01 challenge, injected via sops template env file |
| `invidious-basic-auth-hash` | Raw bcrypt hash for the `arepa` user, embedded in Caddyfile snippet via sops template |

The Cloudflare API token needs DNS edit permissions on the zone (no other permissions required).

### Reference

- [Caddy basic_auth directive](https://caddyserver.com/docs/caddyfile/directives/basic_auth)
- [Caddy reverse_proxy directive](https://caddyserver.com/docs/caddyfile/directives/reverse_proxy)
- [Caddy request matchers](https://caddyserver.com/docs/caddyfile/matchers)
- [caddy-dns/cloudflare plugin](https://github.com/caddy-dns/cloudflare)
- [Caddy withPlugins (nixpkgs)](https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/ca/caddy/package.nix)

---

## DNS

**Profile:** `nixos.dns`
**File:** `modules/features/dns.nix`

Provides network-wide ad blocking, local DNS overrides for LAN access to self-hosted
services, and observability via Prometheus and Grafana.

### Stack

- **Blocky** (port 53) - DNS server with ad blocking and custom DNS mapping
- **Unbound** (port 5335) - recursive resolver used as blocky's upstream
- **Prometheus** (port 9090) + **node_exporter** (port 9100) - metrics collection
- **Grafana** (port 3000) - dashboard, available at `http://<host-ip>:3000`

### Grafana dashboards

The node exporter dashboard (Grafana ID 1860) is provisioned automatically. Blocky exposes
Prometheus metrics at `/metrics` (port 4000) and is included as a scrape target.

**Troubleshooting: panels showing raw HTML instead of rendered content**

Grafana sanitizes HTML in panel text by default. Some dashboard panels (including the
node exporter community dashboard) use raw HTML for formatting. If panels display escaped
HTML tags instead of rendered content, set:

```nix
services.grafana.settings.panels.disable_sanitize_html = true;
```

This is already enabled in the module.

### Local DNS override

The `customDNS.mapping` in blocky resolves public service hostnames to the server's LAN IP.
This is necessary because home routers typically do not support hairpin NAT. LAN
devices cannot reach a local server via its public IP through the router.

```nix
customDNS.mapping = {
  "invidious.turboguac.cc" = "192.168.68.100";
};
```

Without this, LAN devices that resolve the domain to the public IP will get a TCP RST
or timeout when the router refuses to hairpin the connection back inward.

To add a new service, add its domain and the server's LAN IP to `customDNS.mapping` and
redeploy the DNS host.

### Reference

- [Blocky documentation](https://0xerr0r.github.io/blocky/latest/)
- [Blocky custom DNS](https://0xerr0r.github.io/blocky/latest/configuration/#custom-dns)
- [Blocky Prometheus metrics](https://0xerr0r.github.io/blocky/latest/api/)
- [Unbound documentation](https://nlnetlabs.nl/documentation/unbound/)
- [Node exporter Grafana dashboard (ID 1860)](https://grafana.com/grafana/dashboards/1860)

---

## Auth Flow

Full request path for an external client:

```
Client
  -> Cloudflare (proxy, TLS termination at edge)
  -> server:443 (Caddy, re-terminates TLS with its own cert)
  -> basic auth check (Caddy, skipped for /api/v1/auth/*)
  -> localhost:3000 (Invidious)
  -> localhost:8282 (invidious-companion, for video URLs)
```

For LAN clients, Blocky resolves the hostname to the server's LAN IP so
traffic goes directly to the server rather than out to Cloudflare and back.

### Yattee setup

1. In Yattee, add the instance URL with credentials embedded:
   `https://arepa:<password>@invidious.<domain>`
2. Log in with your invidious account credentials in the Yattee account settings.
3. Yattee sends basic auth for all requests. For `/api/v1/auth/*` requests it sends
   the invidious session token instead; Caddy passes these through without auth checking.
