<p align="center">
  <img src="https://media1.tenor.com/m/5lFKTvSNpaQAAAAd/jet-black-jet-black-laugh.gif" alt="Jet" width="300"/>
</p>

## Contents

- [Overview](#overview)
- [Profiles Selected](#profiles-selected)
- [Variables](#variables)
- [Disk Layout](#disk-layout)
- [Services](#services)
- [Secrets](#secrets)
- [Bootstrapping](#bootstrapping)
- [Data Migration](#data-migration)
- [Host-Specific Files](#host-specific-files)

---

## Overview

**Platform:** x86_64 NixOS
**Role:** Homelab server -- self-hosted services on the public internet via Cloudflare

Replaces the darwin jet mac mini. Runs Invidious, n8n, and Caddy as native NixOS services,
exposed publicly through Cloudflare-proxied subdomains with TLS handled by Caddy.

- Invidious (YouTube frontend) -- login-only, no public registration
- Invidious-companion -- PO token acquisition for video playback
- PostgreSQL -- managed locally by `services.invidious`
- n8n -- workflow automation with Discord integration
- Caddy -- reverse proxy with Cloudflare DNS plugin for TLS

---

## Profiles Selected

```nix
# modules/hosts/nixos/jet/imports.nix
imports = with config.flake.modules.nixos; [base tailscale invidious n8n caddy];
nixpkgs.hostPlatform = "x86_64-linux";
```

---

## Variables

```nix
var = {
  username = "arturo";
  hostname  = "jet";
  shell     = "zsh";
};
```

---

## Disk Layout

Two NVMe drives in mdadm RAID1 with BTRFS on top. One drive can fail and be swapped
with no data loss. GRUB is installed to both drives declaratively via
`boot.loader.grub.mirroredBoots` -- every `nixos-rebuild switch` keeps both in sync.

```
/dev/nvme0n1
  nvme0n1p1  1G   vfat    /boot          (primary EFI)
  nvme0n1p2  rest mdadm   \
                            md0  (RAID1)  -> BTRFS
/dev/nvme1n1                /
  nvme1n1p1  1G   vfat    /boot/efi-backup  (backup EFI)
  nvme1n1p2  rest mdadm   /
```

BTRFS subvolumes on the RAID array:

| Subvolume | Mountpoint | Purpose |
|-----------|------------|---------|
| `@` | `/` | Root |
| `@home` | `/home` | User home |
| `@nix` | `/nix` | Nix store |
| `@data` | `/var/lib` | Service state (postgres, n8n) |
| `@log` | `/var/log` | Logs |

**Drive failure recovery:**
```bash
mdadm --manage /dev/md0 --add /dev/nvme1n1p2
mdadm --wait /dev/md0
```

---

## Services

### Invidious

- **Module:** `modules/features/invidious/default.nix` -> `flake.modules.nixos.invidious`
- **Port:** 3000 (localhost only, Caddy proxies externally)
- **URL:** `https://invidious.<domain>`
- Login required (`login_only = true`), registration disabled
- Package built from the `invidious` flake input tracking master branch
- Companion binary from `invidious-companion` flake input (`release-master` pre-built binary)
- PostgreSQL provisioned locally by `services.invidious` (`database.createLocally = true`)
- Daily systemd timer (`invidious-update`) rebuilds from the GitHub flake at 04:00, picking up
  any updated flake inputs committed from the workstation

### n8n

- **Module:** `modules/features/n8n/default.nix` -> `flake.modules.nixos.n8n`
- **Port:** 5678 (localhost only, Caddy proxies externally)
- **URL:** `https://n8n.<domain>`
- Discord token injected via sops secret environment file
- Workflow data persisted at `/var/lib/n8n`

### Caddy

- **Module:** `modules/features/caddy/default.nix` -> `flake.modules.nixos.caddy`
- **Ports:** 80, 443 (public)
- Cloudflare DNS plugin for ACME TLS challenge (works with Cloudflare proxied/orange cloud)
- Cloudflare API token injected via sops secret environment file

---

## Secrets

All secrets live in `modules/aspects/secrets/secrets.yaml` (shared with all hosts).

| Secret | Purpose |
|--------|---------|
| `invidious-hmac-key` | Invidious session signing |
| `invidious-extra-settings` | YAML file containing `invidious_companion_key` |
| `invidious-companion-env` | `SERVER_SECRET_KEY` for the companion systemd unit |
| `n8n-discord-token-env` | `DISCORD_TOKEN` for the n8n systemd unit |
| `caddy-cloudflare-env` | `CLOUDFLARE_API_TOKEN` for the Caddy systemd unit |

---

## Bootstrapping

The new Linux jet replaces the darwin jet mac mini. Before first deploy:

1. Update `.sops.yaml` with the new machine's age key:
   ```bash
   # On new machine after booting installer:
   age-keygen -o ~/.config/sops/age/keys.txt
   # Copy the public key, update .sops.yaml, then:
   sops updatekeys modules/aspects/secrets/secrets.yaml
   ```

2. Add all five secrets to `modules/aspects/secrets/secrets.yaml` via `sops`.

3. Fill in `modules/features/caddy/default.nix`:
   - Cloudflare DNS plugin version and hash
   - Your actual domain names

4. Fill in the GitHub username in `modules/features/invidious/default.nix` (nixos-rebuild URL).

5. Boot NixOS installer ISO on the new machine, then from your workstation:
   ```bash
   nix run github:nix-community/nixos-anywhere -- \
     --flake .#jet \
     --target-host nixos@<ip> \
     --generate-hardware-config nixos-facter ./modules/hosts/nixos/jet/facter.json
   ```

6. Commit `facter.json`, uncomment the facter import in `imports.nix`.

See [deploying](../howto/deploying.md) and [age keys](../howto/age-keys.md) for general guidance.

---

## Data Migration

Run after the new machine is up and all services have started at least once.

### PostgreSQL (Invidious)

The NixOS module creates a postgres user named `invidious` (old Docker setup used `kemal`).

```bash
# On old mac mini:
docker exec homelab-invidious-db-1 pg_dump -U kemal -F c invidious > invidious.dump
scp invidious.dump arturo@<new-jet-ip>:~

# On new machine:
systemctl stop invidious.service
sudo -u postgres pg_restore -U invidious -d invidious --clean ~/invidious.dump
systemctl start invidious.service
```

### n8n

```bash
# On old mac mini:
tar czf n8n-data.tar.gz n8n/n8n-data/
scp n8n-data.tar.gz arturo@<new-jet-ip>:~

# On new machine:
systemctl stop n8n.service
sudo tar xzf ~/n8n-data.tar.gz -C /var/lib/n8n/ --strip-components=1
sudo chown -R n8n:n8n /var/lib/n8n/
systemctl start n8n.service
```

After migration, update the webhook URL in n8n settings to `https://n8n.<domain>`.

---

## Host-Specific Files

| File | Purpose |
|------|---------|
| `imports.nix` | Profile selection + `nixpkgs.hostPlatform` |
| `variables.nix` | `var.*` values |
| `disko.nix` | Disk layout (mdadm RAID1, BTRFS, GRUB mirrored boots) |
| `home.nix` | Minimal server HM config |
| `state-version.nix` | `system.stateVersion = "25.05"` |
| `facter.json` | Generated by nixos-anywhere, hardware detection |
