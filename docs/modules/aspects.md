# Aspects

## Contents

- [What Are Aspects](#what-are-aspects)
- [Reference](#reference)

---

## What Are Aspects

Aspects are foundational system concerns applied to every machine of a given type. They define what the system is at a base level -- things every NixOS or Darwin machine always has, regardless of what optional capabilities it uses.

Aspects live in `modules/aspects/` and contribute to `nixos.base` or `darwin.base`. They are not optional -- every host of their category imports them.

Desktop-specific concerns (audio, bluetooth, theming, boot) are **not** aspects -- they live in `features/` and are composed into machine bundles.

See [Features](features.md) for atomic opt-in capabilities and [Bundles](bundles.md) for curated feature groups.

---

## Reference

| Aspect | Path | Profile | Description |
|--------|------|---------|-------------|
| `nix` | `aspects/nix.nix` | `nixos.base` | Nix daemon settings: flakes, nix-command, auto-optimise-store, auto-gc, trusted users, substituters (nixos.org + hyprland cache) |
| `users` | `aspects/users.nix` | `nixos.base` | Primary user account from `var.username`, shell enablement via `programs.${var.shell}.enable`, sudo |
| `networking` | `aspects/networking.nix` | `nixos.base` | Hostname from `var.hostname`, NetworkManager, timezone (America/New_York), locale (en_US.UTF-8), openssh |
| `secrets` | `aspects/secrets/` | `nixos.base` | sops-nix: `defaultSopsFile = ./secrets.yaml`, age key at `~/.config/sops/age/keys.txt`, secret declarations |
| `darwin` | `aspects/darwin.nix` | `darwin.base` | macOS system config: Dock, Finder, keyboard remapping, dark mode, Homebrew, user shell, sops-nix secrets |

### Flake-level infrastructure

These live in `modules/flake/` rather than `aspects/` because they are flake-parts plumbing, not system concerns:

| Module | Path | Description |
|--------|------|-------------|
| `var` | `flake/var/` | Variable schema definition (`options.var.*`) contributed to base profiles |
| `owner` | `flake/owner/` | `flake.meta.owner.username`, the single place to set the primary username |
| home-manager bridges | `flake/home-manager/` | Wires NixOS/Darwin profiles to Home Manager profiles |
