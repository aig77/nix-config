# Aspects

## Contents

- [What Are Aspects](#what-are-aspects)
- [Reference](#reference)

---

## What Are Aspects

Aspects are foundational system concerns applied broadly. They define what the system is at a base level, not what it can optionally do. An aspect isn't something a host picks up for a specific capability; it's a concern that belongs to every machine in its category (all NixOS machines, all desktop machines, etc.).

Aspects live in `modules/aspects/` and contribute to the `base` and `desktop` NixOS profiles, or to profiles that represent hardware reality rather than an optional capability.

See [Features](features.md) for atomic capabilities and the Bundles section in the repo for curated feature groups.

---

## Reference

| Aspect | Path | Profile | Description |
|--------|------|---------|-------------|
| `nix` | `aspects/nix/` | `nixos.base` | Nix daemon settings: flakes, nix-command, auto-optimise-store, auto-gc, trusted users, substituters (nixos.org + hyprland cache) |
| `users` | `aspects/users/` | `nixos.base` | Primary user account from `var.username`, shell enablement, groups (networkmanager, audio, video, etc.), sudo |
| `networking` | `aspects/networking/` | `nixos.base` | NetworkManager, firewall with ports 22/80/443 open |
| `secrets` | `aspects/secrets/` | `nixos.base` | sops-nix: `defaultSopsFile = ./secrets.yaml`, age key at `~/.config/sops/age/keys.txt`, secret declarations, weatherapi.json template (Linux only) |
| `boot` | `aspects/boot/` | `nixos.boot` | GRUB2 with EFI, Plymouth boot splash, kernel params for quiet boot |
| `audio` | `aspects/audio/` | `nixos.audio` | PipeWire with PulseAudio compatibility, rtkit for real-time audio, dbus |
| `bluetooth` | `aspects/bluetooth/` | `nixos.bluetooth` | `services.bluetooth` enabled, `blueman` applet |
| `theme` | `aspects/theme/` | `nixos.theme` / `darwin.base` | Stylix: Catppuccin Mocha, JetBrains Mono Nerd Font, DejaVu Sans/Serif, Noto Color Emoji, catppuccin cursors, Papirus Dark icons. Wallpaper is not managed here; it's set at runtime by waypaper + awww |
| `darwin` | `aspects/darwin.nix` | `darwin.base` | macOS system config: Dock, Finder, keyboard remapping, dark mode, Homebrew, user shell, sops-nix secrets |

### Flake-level infrastructure

These live in `modules/flake/` rather than `aspects/` because they are flake-parts plumbing, not system concerns:

| Module | Path | Description |
|--------|------|-------------|
| `var` | `flake/var/` | Variable schema definition (`options.var.*`) contributed to base profiles |
| `owner` | `flake/owner/` | `flake.meta.owner.username`, the single place to set the primary username |
| home-manager bridges | `flake/home-manager/` | Wires NixOS/Darwin profiles to Home Manager profiles |

### Spike-specific

| Aspect | Path | Profile | Description |
|--------|------|---------|-------------|
| `volt` | `aspects/audio/volt.nix` | `nixos.volt` | WirePlumber rule that pins the Universal Audio Volt 476 to `analog-surround-40` on connect. Without this, WirePlumber defaults to `pro-audio`, which breaks Discord and normal apps. Switch to `pro-audio` manually via `pactl set-card-profile` when using a DAW |
