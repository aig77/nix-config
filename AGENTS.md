# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

**Style note:** Do not use em dashes (—) in documentation or code comments.

## What This Is

**Bebop** is a Nix Flakes + flake-parts system configuration managing five machines from a single repo: three NixOS machines (x86_64 desktop, x86_64 HTPC, aarch64 RPi server) and two macOS machines (aarch64-darwin).

## Build and Deploy

```bash
# Apply NixOS configuration
sudo nixos-rebuild switch --flake .#spike
sudo nixos-rebuild switch --flake .#faye
sudo nixos-rebuild switch --flake .#ed

# Apply macOS configuration
darwin-rebuild switch --flake .#ein

# Validate all modules (runs pre-commit hooks: alejandra, statix, deadnix)
nix flake check

# Format all Nix files
nix fmt

# Enter dev shell (provides: age, git, neovim, nixd, sops)
nix develop
```

**Critical:** New `.nix` files must be `git add`ed before Nix can see them. import-tree uses git to discover files.

---

## Dendritic Pattern

This is the most important concept for writing code in this repo.

### Auto-import

`flake.nix` passes `./modules` to import-tree, which collects every `.nix` file and merges them as a single flake-parts module. Every file is always imported. Whether a file's config takes effect depends entirely on whether the host imports the relevant named profile.

### Modules expose profiles, not configuration

Modules do not configure systems directly. They expose named profiles that hosts opt into:

```nix
_: {
  flake.modules.nixos.myfeature = {pkgs, config, ...}: {
    services.myfeature.enable = true;
  };
  flake.modules.homeManager.myfeature = {pkgs, config, ...}: {
    programs.myfeature.enable = true;
  };
}
```

Three namespaces:
- `flake.modules.nixos.<name>`: NixOS system modules
- `flake.modules.homeManager.<name>`: Home Manager modules
- `flake.modules.darwin.<name>`: nix-darwin modules

### deferredModule merge

All three namespaces use `deferredModule`. Multiple files can contribute to the same profile name and Nix merges them. No explicit imports between files are needed.

### Hosts select profiles

Hosts import named profiles in their `imports.nix`. Modules never import hosts.

```nix
# modules/hosts/nixos/spike/imports.nix
{config, ...}: {
  configurations.nixos.spike.module = {
    imports = with config.flake.modules.nixos; [
      base desktop hyprland-quickshell amdgpu gaming docker tailscale volt
    ];
  };
}
```

### NixOS to Home Manager bridge

Each module that spans both NixOS and HM owns its own wiring. When a NixOS profile needs HM components, it adds `home-manager.users.${username}.imports = [hm.myprofile]` directly. For example, `features/gaming.nix` declares both `nixos.gaming` (Steam setup) and `hm.gaming` (packages/config), and the NixOS side wires in the HM side directly. Similarly, bundle files in `bundles/hyprland/` import NixOS features and wire HM shells.

`modules/flake/home-manager/nixos.nix` is infrastructure only: it sets up the home-manager NixOS module (useGlobalPkgs, extraSpecialArgs, backupFileExtension) and activates `hm.base` for every user. It does not map profiles.

From within a HM module, `osConfig` accesses NixOS options. `config` accesses HM options only:

```nix
osConfig.sops.secrets.my-secret.path  # NixOS option
osConfig.var.hostname                  # NixOS var
config.programs.zsh.enable             # HM option
```

---

## Repository Structure

```
modules/
├── flake/      # Flake-parts infrastructure: output builders, HM bridges, var schema, dev shell
├── hosts/      # Per-machine definitions (nixos/ and darwin/)
├── aspects/    # Foundational system concerns always active for a machine type (nix, users, networking, secrets, darwin)
├── bundles/    # Curated compositions of features (machines, shells, gui, hyprland variants, desktopShells)
└── features/   # Atomic app and service configs - flat .nix files by default, directories only when a concept spans multiple files
```

The 4-tier hierarchy: aspects are always-on foundational concerns, features are atomic opt-in capabilities, bundles compose features into machine-type or desktop profiles, hosts select from all tiers directly.

Where new code belongs:
- New feature (single app or service): `modules/features/<name>.nix`
- New feature spanning NixOS + HM: `modules/features/<name>/` with `nixos.nix`, `home.nix` etc.
- New bundle (group of features): `modules/bundles/<name>.nix`
- New aspect (foundational concern): `modules/aspects/<name>/`
- New host: `modules/hosts/nixos/<hostname>/` or `modules/hosts/darwin/<hostname>/`
- Flake-parts infrastructure: `modules/flake/`

---

## Variable Schema

Hosts set typed variables; feature modules read them. Never hardcode hostnames, usernames, or paths that vary between hosts.

### NixOS (`modules/flake/var/default.nix`)

| Option | Default | Description |
|--------|---------|-------------|
| `var.username` | | System username |
| `var.hostname` | | Machine hostname |
| `var.shell` | | `"zsh"` or `"fish"` |
| `var.terminal` | `"ghostty"` | Default terminal |
| `var.browser` | `"zen"` | Default browser |
| `var.location` | `""` | City for weather widgets |
| `var.launcher` | `"fuzzel"` | App launcher |
| `var.fileManager` | `"nautilus"` | File manager |
| `var.lock` | `"hyprlock"` | Lock screen command |
| `var.logout` | `"wlogout"` | Logout menu command |
| `var.wallpaperEngine` | `"swww"` | Wallpaper backend |
| `var.wallpaperPath` | `"$HOME/.cache/bebop/current-wallpaper"` | Runtime wallpaper symlink |

### Darwin (`modules/flake/var/darwin.nix`)

Smaller set: `username`, `hostname`, `shell`, `terminal`, `browser`.

---

## Module Function Forms

```nix
# No flake-parts inputs needed - use _: to avoid statix warnings
_: {
  flake.modules.nixos.myfeature = {pkgs, config, lib, ...}: {
    # NixOS module body
  };
}

# With flake-parts inputs
{config, inputs, lib, ...}: {
  flake.modules.nixos.myfeature = {pkgs, ...}: {
    environment.systemPackages = [inputs.something.packages.${pkgs.system}.default];
  };
}
```

---

## Common Issues

**New file not picked up:** Run `git add <file>`. import-tree uses git to list files.

**`error: attribute 'X' missing` in HM module:** Use `osConfig.X` for NixOS options from within HM. `config.X` inside HM is the HM config only.

**`statix` warning:** Replace `{...}:` with `_:` when no named args are used.

**`deadnix` warning:** Remove unused variables from the function argument pattern.

**OBS and other Linux-only packages:** Guard with `lib.mkIf pkgs.stdenv.isLinux { ... }`.

---

## Full Documentation

- [Architecture](docs/architecture.md): dendritic pattern, profiles, bridges, var schema, theming, secrets
- [Aspects](docs/modules/aspects.md): foundational system modules reference
- [Features](docs/modules/features.md): opt-in capability modules reference
- [Flake-Parts Infrastructure](docs/flake-parts.md): output builders, bridges, dev shell
- [Hosts](docs/hosts/): per-machine details (spike, ein, faye, jet, ed)
- [How-To Guides](docs/howto/): deploying, adding modules/hosts, secrets, age keys, inputs
