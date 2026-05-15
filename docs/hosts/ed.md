<p align="center">
  <img src="https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExb3RkNWthcWVjNm1wcjIxdDNmNGx6em4yYzh0anp6bTV2dmdrcTloMiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/udhngZK2IFTc4/giphy.gif" alt="Ed" width="300"/>
</p>

## Contents

- [Overview](#overview)
- [Profiles Selected](#profiles-selected)
- [Variables](#variables)
- [Host-Specific Files](#host-specific-files)

---

## Overview

**Platform:** aarch64 NixOS
**Role:** Headless Raspberry Pi server

Handles network services. No GUI, no desktop stack. Runs DNS and monitoring only.

- Blocky DNS server with ad-blocking (StevenBlack hosts list)
- Unbound recursive resolver with DNSSEC
- Prometheus metrics collection
- Grafana dashboards for monitoring
- Auto-expanding root partition, watchdog for auto-reboot
- Builds as a flashable SD card image (`nix build .#images.ed`)

---

## Profiles Selected

```nix
# modules/hosts/nixos/ed/imports.nix
imports = with config.flake.modules.nixos; [
  base
  server
  tailscale
  dns
];
nixpkgs.hostPlatform = "aarch64-linux";
nix.settings.filter-syscalls = false;
```

`server` activates autologin and wires `hm.shell-lite`. It also overrides `sops.age.keyFile` to `/etc/sops/age/keys.txt`.

`nix.settings.filter-syscalls = false` is required on aarch64 Raspberry Pi kernels, which do not fully support the seccomp syscall filtering used by the Nix sandbox.

---

## Variables

```nix
var = {
  username = "arturo";
  hostname = "ed";
  shell    = "zsh";
};
```

---

## Host-Specific Files

| File | Purpose |
|------|---------|
| `imports.nix` | Profile selection, `nixpkgs.hostPlatform`, `filter-syscalls` |
| `variables.nix` | `var.*` values |
| `hardware.nix` | Boot loader (generic-extlinux-compatible), grow partition, filesystem, watchdog |
| `home.nix` | Minimal HM home config (`stateVersion` only) |
| `state-version.nix` | `system.stateVersion = "25.05"` |
