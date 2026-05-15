# Bundles

## Contents

- [What Are Bundles](#what-are-bundles)
- [System Bundles](#system-bundles)
- [Desktop Environment Bundles](#desktop-environment-bundles)
- [Desktop Shell Bundles](#desktop-shell-bundles)

---

## What Are Bundles

Bundles are curated groups of features composed into higher-level profiles for easy reuse. Rather than importing individual features, hosts import a bundle that brings in a coherent set of related features.

Bundles live in `modules/bundles/` and can be single `.nix` files or directories containing multiple variant files. Bundles import features and/or aspects, and may expose one or more named profiles for hosts to select.

---

## System Bundles

These compose foundational features into logical groups.

| Bundle | Path | Profiles | Description |
|--------|------|----------|-------------|
| Shell | `bundles/shell.nix` | `hm.shell` | Terminal tools: zsh, fish, fzf, tmux, starship, zoxide, direnv, CLI packages. Imported by hosts that want a full shell environment |
| GUI | `bundles/gui.nix` | `hm.gui` | GUI applications: zen, helium, ghostty, alacritty, discord, spotify, obs, obsidian, zathura. Imported by desktop hosts |
| Desktop | `bundles/desktop.nix` | `nixos.desktop` | Full NixOS desktop stack: imports audio, bluetooth, boot, theme, thunar aspects and wires HM shell, gui, eyecandyNixos. The primary profile desktop hosts use |
| Eyecandy | `bundles/eyecandy.nix` | `hm.eyecandyBase`, `hm.eyecandyNixos`, `darwin.eyecandy` | Terminal eyecandy: fastfetch, fetchGreeting, cava, ASCII art packages. `eyecandyBase` for macOS, `eyecandyNixos` adds tty-clock and is wired into desktop |
| Wallpaper | `bundles/wallpaper.nix` | `hm.wallpaperManager` | Wallpaper management: waypaper GTK picker and awww daemon. Conditionally includes awww if `var.wallpaperEngine == "awww"` |

---

## Desktop Environment Bundles

Complete NixOS+HM desktop configurations for different window managers. Each enables the WM at the system level and wires in the corresponding HM config.

| Bundle | Path | Profiles | Description |
|--------|------|----------|-------------|
| Hyprland (base) | `bundles/hyprland.nix` (not a bundle dir) | `nixos.hyprland`, `hm.hyprland` | Base Hyprland WM: GDM, portal setup (NixOS), keybinds/animations/window rules (HM). Not used directly by hosts; imported by variant bundles below |
| Hyprland + Custom | `bundles/hyprland/custom.nix` | `nixos.hyprland-custom` | Hyprland with Waybar + SwayNC. Imports `nixos.hyprland`, wires `hm.hyprland`, `hm.waybarShell`, `hm.screenshot` |
| Hyprland + HyprPanel | `bundles/hyprland/hyprpanel.nix` | `nixos.hyprland-hyprpanel` | Hyprland with HyprPanel bar. Imports `nixos.hyprland`, wires `hm.hyprland`, `hm.hyprpanelShell`, `hm.screenshot` |
| Hyprland + Quickshell | `bundles/hyprland/quickshell.nix` | `nixos.hyprland-quickshell` | Hyprland with Quickshell bar/launcher. Imports `nixos.hyprland`, wires `hm.hyprland`, `hm.quickshellShell`, `hm.screenshot`, sets `var.launcher = "quickshell"` |
| Niri | `features/niri/nixos.nix` | `nixos.niri` | Niri WM: GDM, session setup (NixOS), keybinds/wallpaper/Waybar config (HM files in feature). Not a bundle but a multi-file feature |
| GNOME | `features/gnome.nix` | `nixos.gnome`, `hm.gnome` | GNOME: GDM, GNOME packages, shell extensions. Single-file feature combining both layers |

---

## Desktop Shell Bundles

Bundles that compose desktop environment components (bar, lock, idle, wallpaper) into cohesive HM shells. Used by variant WM bundles above.

| Bundle | Path | Profile | Features | Description |
|--------|------|---------|----------|-------------|
| Waybar Shell | `bundles/desktopShells/waybar.nix` | `hm.waybarShell` | waybar, swaync, fuzzel, hyprlock, hypridle, wallpaperManager | Waybar status bar + notification daemon + launcher + lock/idle + wallpaper. Used by Hyprland custom variant |
| HyprPanel Shell | `bundles/desktopShells/hyprpanel.nix` | `hm.hyprpanelShell` | hyprpanel, hyprlock, hypridle, fuzzel | HyprPanel bar + launcher + lock/idle. Used by Hyprland hyprpanel variant |
| Quickshell Shell | `bundles/desktopShells/quickshell.nix` | `hm.quickshellShell` | quickshell, fuzzel, hyprlock, hypridle, wallpaperManager | Quickshell widget framework bar + launcher + lock/idle + wallpaper. Used by Hyprland quickshell variant |

---

## Composition Example

How bundles fit into the hierarchy:

```
Host (spike) imports:
  - nixos.base (aspect)
  - nixos.desktop (bundle = audio + bluetooth + boot + theme + thunar aspects + HM wiring)
    - which imports hm.shell, hm.gui, hm.eyecandyNixos (bundles)
  - nixos.hyprland-quickshell (bundle = hyprland base + quickshell shell)
    - which imports hm.hyprland + hm.quickshellShell (bundles)
  - nixos.amdgpu (feature)
  - nixos.gaming (feature)
  - nixos.docker (feature)
  - nixos.tailscale (feature)
  - nixos.volt (feature)
```

Each tier composes the layer below: features are atomic, bundles group features, aspects group foundational concerns, hosts select from all three tiers plus bundles.
