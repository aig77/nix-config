# Server Services

How self-hosted services get declared, exposed, authenticated, and backed up. The heavy lifting lives in a handful of modules; this page explains how they fit together.

## The `var.services` registry

Every service feature registers itself in `var.services` (schema in `modules/flake/var/nixos.nix`). A service entry looks like:

```nix
var.services.vaultwarden = {
  subdomain = "vault";
  port = config.ports.vaultwarden;
  public = true;
  auth = false;
  backup = {
    paths = ["/var/lib/backups/vaultwarden"];
    prepareCommand = "...";
  };
};
```

Fields:

- `subdomain` - hostname under the public domain (or tailnet hostname)
- `port` - where the service listens on localhost; pull it from the port registry, never invent your own number
- `public` - `true` for internet-exposed services, `false` for tailnet-only
- `auth` - gate the public vhost behind basic auth
- `backup` - optional; `paths` plus an optional `prepareCommand` that stages a consistent snapshot
- `monitor` - optional; gatus auto-registers a health check (http/tcp, path, thresholds, interval)
- `homepage` - optional; glance auto-links the service (title, icon)

Ports live in one place, `modules/flake/ports.nix`. Features read them via `config.ports.<name>`; nothing hardcodes a port number.

Six modules consume the registry and react to these flags. None of them know about individual services:

| Module | Reacts to | Effect |
|--------|-----------|--------|
| `features/caddy.nix` | `public` + `auth` | Vhost + TLS + basic auth for public services |
| `features/cloudflared.nix` | `public` | Tunnel ingress rule for public services |
| `features/tailscale.nix` | `!public` | `tailscale serve` for private services |
| `features/backup.nix` | `backup` | One restic job covering all backed-up services |
| `features/gatus.nix` | `monitor.enable` | Health-check endpoint on the Bebop dashboard |
| `features/glance.nix` | `homepage.enable` | Homepage site entry |

## Adding a service

1. Reserve a port in `modules/flake/ports.nix` (or reuse an existing one).
2. Create a feature that runs the app on localhost only and sets `var.services.<name>` with `port = config.ports.<name>`.
3. Choose exposure:
   - **Public**: `public = true`. The host needs `caddy` + `cloudflared` imported. Add `auth = true` if it should be behind basic auth.
   - **Private**: `public = false`. The host needs the `server` bundle (it wires in `tailscale-http`). Reachable over the tailnet, no caddy involved.
   Optionally add a `monitor` block for an automatic gatus health check, and a `homepage` block so glance links the service. Both default to off; see the field list above.
4. `git add` the new file, run `nix flake check`.

## Public exposure: Caddy + Cloudflared

Public services are reached through a Cloudflare tunnel. The path is:

```
Client -> Cloudflare edge (TLS) -> tunnel -> cloudflared (localhost) -> Caddy (localhost) -> service
```

- **Caddy** (`features/caddy.nix`) terminates TLS with its own certs via the Cloudflare DNS-01 plugin, then reverse-proxies to `localhost:<port>`. For each public service it emits a vhost for `<subdomain>.<domain>`; the domain comes from the `cloudflare/service-domain` sops secret.
- **Cloudflared** (`features/cloudflared.nix`) maps each public service to an ingress rule pointing at `https://localhost` with TLS verification disabled, since Caddy already terminated it. Tunnel ID and credentials come from sops secrets.

### Auth

With `auth = true`, Caddy imports a basic auth snippet rendered from sops (`caddy/basic-auth-user`, `caddy/basic-auth-hash`). The hash is a raw bcrypt string, embedded via a template so it avoids the base64 encoding Caddy's JSON config path requires.

To rotate the password:

```bash
nix shell nixpkgs#caddy --command caddy hash-password
sops modules/aspects/secrets/secrets.yaml   # replace caddy/basic-auth-hash
nh os switch -H <host>
```

Invidious gets one extra rule: `/api/v1/auth/*` bypasses basic auth because API clients send their session token in the `Authorization` header, which `basic_auth` would otherwise consume.

### Updating the Caddy Cloudflare plugin

Caddy is built with `withPlugins`, which compiles caddy plus the Go plugins from source. A plugin bump means updating **both** the version and the source hash:

```nix
package = pkgs.caddy.withPlugins {
  plugins = ["github.com/caddy-dns/cloudflare@v0.2.4"];
  hash = "sha256-...";   # combined caddy + plugin source hash
};
```

The hash covers the whole Go module set, not just the plugin, which is why it looks unrelated to any individual plugin version. To update:

```bash
# latest revision
nix run nixpkgs#nix-prefetch-github -- caddy-dns cloudflare
# Go module version for that revision
nix shell nixpkgs#go --command go list -m github.com/caddy-dns/cloudflare@<rev>
```

Then set `hash = lib.fakeHash`, build, and copy the `got:` value from the hash mismatch error. The `@vX.Y.Z` version and the hash have to move together, so pin both in the same commit.

## Private exposure: Tailscale HTTPS

Private services (`public = false`) are served straight over the tailnet. `features/tailscale.nix` contributes `tailscale-http`, which runs one `tailscale serve` command per private service on its own port:

```bash
tailscale serve --bg --https=<port> http://localhost:<port>
```

Each service is reachable at `https://<host>.<tailnet>:<port>`. The one exception is glance, which is special-cased onto 443. No caddy, no cloudflared, no firewall opening needed. `tailscale serve reset` is wired into the service stop so the whole mapping collapses on rebuild.

## Backups

Services opt in with a `backup` block. `features/backup.nix` collects every service that has one, concatenates the `prepareCommand`s (which stage consistent snapshots into `/var/lib/backups`, e.g. `pg_dump` or sqlite `.backup`), and runs a single restic job per host at 02:00 into a Cloudflare R2 bucket. Retention is pruned automatically.

Restore:

```bash
set -a; source /run/secrets/restic.env; set +a
export RESTIC_PASSWORD="$(cat /run/secrets/restic/password)"
restic snapshots
restic restore latest --target /tmp/restore --path /var/lib/backups/<service>
```

## Invidious

`features/invidious.nix` runs invidious alongside `invidious-companion`, which handles PO token acquisition so video playback works. Both are built from flake inputs tracking upstream master rather than nixpkgs. A daily timer rebuilds from the GitHub flake, and a monitor service restarts the rebuild if the instance stays down.

## DNS

`features/dns.nix` is the LAN side of the self-hosted stack:

- **Blocky** - DNS server with ad blocking, plus a `customDNS.mapping` that resolves public service hostnames to the server's LAN IP. This exists because home routers usually don't do hairpin NAT, so LAN devices can't reach the server through its public IP.
- **Unbound** - recursive resolver acting as Blocky's upstream.
- **Prometheus + Grafana** - metrics collection and dashboards, the node exporter dashboard provisioned automatically.

Ports and scrape targets come from the registry and `prometheus.nix`, not from this doc.
