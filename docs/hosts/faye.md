<p align="center">
  <img src="https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExN3lydDhpM3dqbTU2azI0aGxmZ3F2ZjVqdWgxc2VtYTA5bzloOHQ4ciZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/10VjiVoa9rWC4M/giphy.gif" alt="Faye" width="300"/>
</p>

## Contents

- [Overview](#overview)
- [Profiles Selected](#profiles-selected)
- [Variables](#variables)
- [Host-Specific Files](#host-specific-files)

---

## Overview

**Platform:** x86_64 NixOS
**Role:** HTPC

Living room media machine. AMD GPU, Hyprland desktop, configured for media playback.

---

## Profiles Selected

```nix
# modules/hosts/nixos/faye/imports.nix
imports = with config.flake.modules.nixos; [
  base
  desktop
  amdgpu
  htpc
  no-rgb
];
```

---

## Variables

```nix
var = {
  username    = "arturo";
  hostname    = "faye";
  shell       = "zsh";
  terminal    = "ghostty";
  browser     = "zen";
  fileManager = "thunar";
};
```

---

## Host-Specific Files

| File | Purpose |
|------|---------|
| `imports.nix` | Profile selection |
| `variables.nix` | All `var.*` values |
| `hardware.nix` | Kernel modules, AMD microcode, hostPlatform |
| `disko.nix` | Disk layout for fresh installs (nixos-anywhere) |
| `home.nix` | Faye-specific HM packages |
| `state-version.nix` | `system.stateVersion = "25.05"` |
