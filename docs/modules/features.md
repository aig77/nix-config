# Features

## Contents

- [What Are Features](#what-are-features)
- [When to Use a Feature vs. a Bundle vs. an Aspect](#when-to-use-a-feature-vs-a-bundle-vs-an-aspect)
- [Desktop Environments](#desktop-environments)
- [Desktop Components](#desktop-components)
- [System Services](#system-services)
- [Applications](#applications)
- [Darwin-Specific](#darwin-specific)

---

## What Are Features

Features are atomic apps and services that a host explicitly selects. They represent single, self-contained concerns: an app, a service, a component. Features are the building blocks that bundles compose together.

Features live in `modules/features/` and contribute to named profiles that hosts or bundles import. A feature file is usually a single `.nix` file, but can be a directory with multiple files when a concept genuinely spans multiple files (for example, a NixOS-side file and a Home Manager-side file for the same program).

See [Aspects](aspects.md) for foundational system concerns. See [Bundles](bundles.md) for curated feature groups.

---

## When to Use a Feature vs. a Bundle vs. an Aspect

| Situation | Use |
|-----------|-----|
| Single app or service that hosts opt into individually | Feature |
| Group of features that always appear together for a machine type or desktop | Bundle |
| System concern that every machine of a platform type must always have | Aspect |

A feature is the right choice when the capability is independently meaningful and some hosts want it without the others. A bundle is the right choice when combining several features into a single named profile simplifies host configuration. An aspect is the right choice only when the concern is truly universal for a platform - things like the Nix daemon, user accounts, or timezone settings.

When in doubt, start with a feature. Bundles are an optimization applied once you see a repeated pattern across host `imports.nix` files.

---

## Desktop Environments

Full compositor/WM setups. Each owns its system-level enablement and HM configuration.

| Feature | Path | Profiles | Description |
|---------|------|----------|-------------|
| Hyprland (base) | `features/hyprland/` | `nixos.hyprland`, `hm.hyprland` | System enablement + portals (`nixos.hyprland`), Lua config symlinked to `hypr/` at build time (`hm.hyprland`). Config entry point is `hyprland.lua`; sub-modules in `hypr/config/` cover animations, autostart, binds, env, general, monitors, permissions, rules. `stylix.targets.hyprland` is disabled to prevent HM generating a conflicting `hyprland.conf`. Not used directly; hosts import one of the variant bundles. |
| Niri | `features/niri/` | `nixos.niri`, `hm.niri` | GDM + Niri session (nixos.nix), keybinds/rules/wallpaper (home.nix), niri-specific Waybar (waybar.nix) |
| GNOME | `features/gnome/` | `nixos.gnome`, `hm.gnome` | GDM + GNOME packages (nixos.nix), shell extensions via dconf (extensions.nix) |

---

## Desktop Components

Standalone components composable across multiple WM setups.

| Feature | Path | Profile | Description |
|---------|------|---------|-------------|
| Waybar | `features/waybar/` | `hm.waybar` | Status bar for niri and Hyprland custom shell |
| SwayNC | `features/notifications/` | `hm.swaync` | Notification center/daemon |
| Hyprlock | `features/hyprlock/` | `hm.hyprlock` | Lock screen with Stylix-themed background from `var.wallpaperPath`, blur |
| Hypridle | `features/hypridle/` | `hm.hypridle` | Idle daemon: dim at 4min, lock at 5min, suspend at 10min |
| Fuzzel | `features/fuzzel/` | `hm.fuzzel` | App launcher shared between Hyprland and niri |
| Quickshell | `features/quickshell/` | `hm.quickshell` | Quickshell bar/launcher widget framework |
| HyprPanel | `features/hyprpanel/` | `hm.hyprpanel` | HyprPanel bar config; layout varies by hostname |
| Wallpaper | `features/wallpaper/` | `hm.wallpaperManager` | swww daemon + waypaper GTK picker |
| Screenshot | `features/screenshot/` | `hm.screenshot` | grimblast scripts bound to Print keys |
| File manager | `features/thunar.nix` | `nixos.thunar` | Thunar with archive and media tag plugins, udisks2, gvfs, tumbler |
| Theme (Linux) | `features/theme/linux.nix` | `nixos.theme` | Stylix: Catppuccin Mocha, JetBrains Mono Nerd Font, catppuccin cursors, Papirus Dark icons |
| Theme (Darwin) | `features/theme/darwin.nix` | `darwin.base` | Stylix theming for macOS: Catppuccin Mocha, JetBrains Mono Nerd Font |

---

## System Services

NixOS-level opt-in services.

| Feature | Path | Profile | Description |
|---------|------|---------|-------------|
| SDDM | `features/sddm.nix` | `nixos.sddm` | SDDM display manager with sddm-astronaut theme, Stylix colors (base0E accent, base00 background), monospace font. Wayland mode disabled (weston crashes on RDNA 4). A system service syncs the current wallpaper to `/var/lib/sddm/` before the display manager starts; a user path unit re-syncs on wallpaper change during the session. |
| Audio | `features/audio.nix` | `nixos.audio` | PipeWire with PulseAudio compatibility, rtkit, dbus |
| Bluetooth | `features/bluetooth.nix` | `nixos.bluetooth` | `services.bluetooth` enabled, blueman applet |
| Boot | `features/grub.nix` | `nixos.grub` | GRUB2 with EFI, Plymouth boot splash, quiet boot kernel params, binfmt aarch64 emulation |
| AMD GPU | `features/amdgpu/` | `nixos.amdgpu` | AMD GPU via `hardware.amdgpu`, ROCm for compute, OpenGL, Vulkan |
| NVIDIA GPU | `features/nvidia/` | `nixos.nvidia` | NVIDIA proprietary drivers, modesetting, power management |
| Gaming | `features/gaming.nix` | `nixos.gaming`, `hm.pcGaming`, `nixos.steamos` | Steam + Proton + GameMode (nixos.gaming), Lutris/Bottles/Heroic/Protonplus (hm.pcGaming), Jovian NixOS SteamOS mode (nixos.steamos) |
| Docker | `features/docker/` | `nixos.docker` | Docker daemon, adds user to `docker` group |
| Tailscale | `features/tailscale/` | `nixos.tailscale` | Tailscale VPN service, opens firewall UDP 41641 |
| Invidious | `features/invidious.nix` | `nixos.invidious` | YouTube frontend + invidious-companion, auto-updates daily. See [server modules](server.md) |
| Caddy | `features/caddy.nix` | `nixos.caddy` | Reverse proxy with Cloudflare DNS plugin for ACME TLS, basic auth. See [server modules](server.md) |
| DNS | `features/dns.nix` | `nixos.dns` | Blocky ad-blocking DNS + Unbound recursive resolver, Prometheus + Grafana. See [server modules](server.md) |
| Volt | `features/volt.nix` | `nixos.volt` | WirePlumber rule that pins the Universal Audio Volt 476 to `analog-surround-40` on connect (spike-specific) |

---

## Applications

All Home Manager modules.

### Shell and Terminal

| Feature | Path | Profile | Description |
|---------|------|---------|-------------|
| ZSH | `features/zsh.nix` | `hm.zsh` | Completions, autosuggestions, syntax highlighting, vi mode, fzf-tab. Active when `var.shell == "zsh"` |
| Fish | `features/fish.nix` | `hm.fish` | Fish shell config and abbreviations. Active when `var.shell == "fish"` |
| Starship | `features/starship.nix` | `hm.starship` | Cross-shell prompt |
| Direnv | `features/direnv.nix` | `hm.direnv` | Automatic dev shell activation with nix-direnv |
| FZF | `features/fzf.nix` | `hm.fzf` | Fuzzy finder with shell integration |
| Zoxide | `features/zoxide.nix` | `hm.zoxide` | Smart `cd` replacement |
| Tmux | `features/tmux.nix` | `hm.tmux` | Tmux with Catppuccin theme |
| Neovim | `features/neovim/` | `hm.neovim` | LSP, treesitter, mini.nvim, mason. Config lives in `features/neovim/nvim/` and is symlinked to `~/.config/nvim` at build time via `mkOutOfStoreSymlink`. Edits take effect immediately without a rebuild. Symlink target is derived from `var.repoPath`. |
| Vim | `features/editor/vim.nix` | `hm.vim` | Minimal vim config as fallback |
| Git | `features/git/git.nix` | `hm.git` | Username from `var.username`, email from sops secret at runtime |
| Lazygit | `features/git/lazygit.nix` | `hm.lazygit` | Lazygit TUI with Catppuccin theme |
| Claude | `features/claude.nix` | `hm.claude` | Claude Code CLI |

### GUI Applications

| Feature | Path | Profile | Description |
|---------|------|---------|-------------|
| Ghostty | `features/ghostty.nix` | `hm.ghostty` | Ghostty terminal. Active when `var.terminal == "ghostty"` |
| Alacritty | `features/alacritty.nix` | `hm.alacritty` | Alacritty as fallback terminal. Active when `var.terminal == "alacritty"` |
| Zen browser | `features/zen.nix` | `hm.zen` | Privacy-hardened Firefox fork |
| Nixcord | `features/nixcord.nix` | `hm.nixcord` | Discord via Nixcord (Vencord-patched) |
| Spotify | `features/spotify.nix` | `hm.spotify` | Spotify via spicetify-nix with Catppuccin theme |
| OBS | `features/obs.nix` | `hm.obs` | OBS Studio, Linux only. Includes obs-pipewire-audio-capture |
| Obsidian | `features/obsidian.nix` | `hm.obsidian` | Obsidian note-taking |
| Zathura | `features/zathura.nix` | `hm.zathura` | Zathura PDF viewer |

---

## Darwin-Specific

| Feature | Path | Profile | Description |
|---------|------|---------|-------------|
| Eyecandy (base) | `features/eyecandy/` | `hm.eyecandy-base` | fastfetch, fetchGreeting, ASCII art packages |
| Eyecandy (NixOS) | `features/eyecandy/` | `hm.eyecandy-nixos` | eyecandy-base + cava + tty-clock |

---

## Using Config Files Without NixOS

Some config directories in this repo (e.g. `modules/features/neovim/nvim/`) are usable standalone on any machine without deploying the full NixOS config. Use sparse checkout to clone only what you need:

```bash
git clone --no-checkout --filter=blob:none https://github.com/aig77/bebop ~/.config/bebop
cd ~/.config/bebop
git sparse-checkout init --cone
git sparse-checkout set modules/features/neovim/nvim
git checkout main
```

Then symlink manually:

```bash
ln -s ~/.config/bebop/modules/features/neovim/nvim ~/.config/nvim
```

On a managed NixOS host the symlink is created automatically at rebuild time. The manual step is only needed on unmanaged machines.
