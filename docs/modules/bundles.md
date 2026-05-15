# Bundles

## Contents

- [What Are Bundles](#what-are-bundles)
- [Machine Bundles](#machine-bundles)
- [Shell Bundles](#shell-bundles)
- [GUI Bundle](#gui-bundle)
- [Eyecandy Bundle](#eyecandy-bundle)
- [Desktop Environment Bundles](#desktop-environment-bundles)
- [Desktop Shell Bundles](#desktop-shell-bundles)

---

## What Are Bundles

Bundles are curated groups of features composed into higher-level profiles for easy reuse. Rather than importing individual features, hosts import a bundle that brings in a coherent set of related features.

Bundles live in `modules/bundles/` and can be single `.nix` files or directories with multiple variant files.

---

## Machine Bundles

`bundles/machines.nix` defines machine-type profiles. Each profile composes the right features and wires in the appropriate HM shell for that machine category.

| Profile | HM Shell | NixOS Features | HM Apps |
|---------|----------|----------------|---------|
| `nixos.desktop` | `hm.shell` | audio, bluetooth, grub, desktop-extras, theme, thunar | eyecandy-nixos, gui, obs, obsidian, spotify, zathura, zen |
| `nixos.laptop` | `hm.shell` | audio, bluetooth, grub, desktop-extras, theme, thunar | eyecandy-nixos, gui |
| `nixos.htpc` | `hm.shell-lite` | audio, bluetooth, grub, desktop-extras, theme, thunar | gui |
| `nixos.server` | `hm.shell-lite` | (none -- server has no desktop stack) | |
| `nixos.desktop-extras` | | xserver/xkb, gnome-keyring, printing, polkit | |

`nixos.desktop-extras` is a helper profile imported by all desktop-type machines. It is not used directly by hosts.

---

## Shell Bundles

`bundles/shells.nix` defines HM shell profiles. The correct shell (zsh or fish) is selected dynamically via `hm.${var.shell}`.

| Profile | Contents | Used By |
|---------|----------|---------|
| `hm.shell` | Selected shell + claude, fzf, git, lazygit, neovim, vim, tmux, starship, zoxide + dev tools (rust, go, python) + CLI packages | desktop, laptop |
| `hm.shell-lite` | Selected shell + fzf, tmux + minimal CLI tools (bat, curl, dig, eza, git, jq, lsof, ncdu, ripgrep, rsync, tldr) | htpc, server |

---

## GUI Bundle

`bundles/gui.nix` -- `hm.gui`

Terminal selected dynamically via `hm.${var.terminal}`, plus discord and helium. Machine-specific GUI apps (zen, obs, obsidian, spotify, zathura) are wired directly in `machines.nix` per machine type.

---

## Eyecandy Bundle

`bundles/eyecandy.nix` defines terminal eyecandy profiles.

| Profile | Contents |
|---------|----------|
| `hm.eyecandy-base` | fastfetch, fetchGreeting, ASCII art packages (krabby, cmatrix, pipes-rs, cbonsai, etc.) |
| `hm.eyecandy-nixos` | eyecandy-base + cava + tty-clock |
| `darwin.eyecandy` | Darwin NixOS module that wires `hm.eyecandy-base` for the Darwin user |

---

## Desktop Environment Bundles

Complete NixOS+HM desktop configurations for different window managers.

| Bundle | Path | Profiles | Description |
|--------|------|----------|-------------|
| Hyprland + Custom | `bundles/hyprland/custom.nix` | `nixos.hyprland-custom` | Hyprland with Waybar + SwayNC. Imports `nixos.hyprland`, wires `hm.hyprland`, `hm.waybar-shell`, `hm.screenshot` |
| Hyprland + HyprPanel | `bundles/hyprland/hyprpanel.nix` | `nixos.hyprland-hyprpanel` | Hyprland with HyprPanel bar. Imports `nixos.hyprland`, wires `hm.hyprland`, `hm.hyprpanel-shell`, `hm.screenshot` |
| Hyprland + Quickshell | `bundles/hyprland/quickshell.nix` | `nixos.hyprland-quickshell` | Hyprland with Quickshell bar/launcher. Imports `nixos.hyprland`, wires `hm.hyprland`, `hm.quickshell-shell`, `hm.screenshot`, sets `var.launcher = "quickshell"` |

Note: The base `nixos.hyprland` and `hm.hyprland` profiles live in `features/hyprland/` -- the bundles above compose them with a desktop shell.

---

## Desktop Shell Bundles

Bundles that compose desktop environment components (bar, lock, idle, wallpaper) into cohesive HM shells.

| Bundle | Path | Profile | Features | Description |
|--------|------|---------|----------|-------------|
| Waybar Shell | `bundles/desktopShells/waybar.nix` | `hm.waybar-shell` | waybar, swaync, fuzzel, hyprlock, hypridle, wallpaperManager | Waybar + notifications + launcher + lock/idle + wallpaper |
| HyprPanel Shell | `bundles/desktopShells/hyprpanel.nix` | `hm.hyprpanel-shell` | hyprpanel, hyprlock, hypridle, fuzzel | HyprPanel bar + launcher + lock/idle |
| Quickshell Shell | `bundles/desktopShells/quickshell.nix` | `hm.quickshell-shell` | quickshell, fuzzel, hyprlock, hypridle, wallpaperManager | Quickshell widget framework + launcher + lock/idle + wallpaper |

---

## Wallpaper Bundle

`bundles/wallpaper.nix` -- `hm.wallpaperManager`

waypaper GTK picker + swww daemon. Conditionally includes swww if `var.wallpaperEngine == "swww"`.

---

## Composition Example

```
Host (spike) imports:
  - nixos.base (aspects: nix + users + networking + secrets)
  - nixos.desktop (bundle: audio + bluetooth + grub + desktop-extras + theme + thunar + HM wiring)
  - nixos.hyprland-quickshell (bundle: hyprland base + quickshell shell)
  - nixos.amdgpu (feature)
  - nixos.gaming (feature)
  - nixos.docker (feature)
  - nixos.tailscale (feature)
  - nixos.volt (feature)

Host (ed) imports:
  - nixos.base (aspects)
  - nixos.server (bundle: wires hm.shell-lite)
  - nixos.tailscale (feature)
  - nixos.dns (feature)
```
