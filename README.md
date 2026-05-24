<p align="center">
  <img src="https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExMjBjdXI1eHRqZnluc2t0Y2p0a3k0aThseGc2bnM5ZWZrcjdidWd0bSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/3o7bue6KjrDUzqhTJ6/giphy.gif" alt="Swordfish" width="300"/>
</p>

---

A declarative, multi-platform system configuration built with Nix Flakes and flake-parts. One repo manages NixOS desktops, macOS workstations, and a headless ARM server. Everything is reproducible and version-controlled, composed from the same module tree.

## Hosts

| Host | Platform | Role |
|------|----------|------|
| [Spike](docs/hosts/spike.md) | x86_64 NixOS | Desktop workstation: Hyprland, AMD GPU, gaming, full dev environment |
| [Faye](docs/hosts/faye.md) | x86_64 NixOS | HTPC: media playback, AMD GPU |
| [Ed](docs/hosts/ed.md) | aarch64 NixOS | Headless Raspberry Pi: DNS, ad-blocking, monitoring |
| [Ein](docs/hosts/ein.md) | aarch64 Darwin | MacBook, full configuration with Homebrew casks |
| [Jet (NixOS)](docs/hosts/jet-nixos.md) | x86_64 NixOS | Homelab server: Invidious, n8n, Uptime Kuma |
| [Jet (Darwin)](docs/hosts/jet-darwin.md) | aarch64 Darwin | Mac Mini - deprecated, being replaced by NixOS jet |

---

## Documentation

### Architecture & Design

- [Architecture](docs/architecture.md): how the configuration works end to end
  - [Dendritic Pattern](docs/architecture.md#dendritic-pattern)
  - [Auto-Import via import-tree](docs/architecture.md#auto-import-via-import-tree)
  - [Named Profiles](docs/architecture.md#named-profiles)
  - [Module Anatomy](docs/architecture.md#module-anatomy)
  - [NixOS ↔ Home Manager Bridge](docs/architecture.md#nixos--home-manager-bridge)
  - [Darwin ↔ Home Manager Bridge](docs/architecture.md#darwin--home-manager-bridge)
  - [Variable Schema](docs/architecture.md#variable-schema)
  - [Theming](docs/architecture.md#theming)
  - [Secrets](docs/architecture.md#secrets)
- [Flake-Parts Infrastructure](docs/flake-parts.md): output builders, dev shell, hooks, formatter

### Module Reference

- [Aspects](docs/modules/aspects.md): foundational, always-on system concerns
- [Features](docs/modules/features.md): opt-in capabilities selected per host
  - [Desktop Environments](docs/modules/features.md#desktop-environments)
  - [Desktop Components](docs/modules/features.md#desktop-components)
  - [Applications](docs/modules/features.md#applications)
  - [System Services](docs/modules/features.md#system-services)

### How-To Guides

- [Deploying](docs/howto/deploying.md): rebuild and apply configuration to any host
- [Adding a Module](docs/howto/new-module.md): NixOS-only, Home Manager-only, or both-layer modules
- [Adding a Host](docs/howto/new-host.md): new NixOS or Darwin machine end-to-end
- [Managing Secrets](docs/howto/secrets.md): adding and using sops-nix secrets
- [Managing Age Keys](docs/howto/age-keys.md): adding new machines, rotating keys
- [Flake Inputs](docs/howto/flake-inputs.md): adding and updating flake inputs
- [Troubleshooting](docs/howto/troubleshooting.md): common errors and how to fix them

### Service Guides

- [Yattee](docs/services/yattee.md): ad-free YouTube on iPhone, iPad, and Apple TV via Invidious

---

## Todo

**Quickshell: keyboard-driven control center (vim binds)**
- [x] Clock
- [ ] Calendar
- [ ] Make calendar scrollable between different months up to 5 years later
- [x] Weather
- [ ] Notification center
- [ ] Add bell icon
- [ ] Add clear button
- [ ] Display notifications in the same way that they show up from the notification daemon
- [x] Brightness and volume sliders
- [x] System metrics (CPU, GPU, RAM, storage)
- [x] Blue light filter toggle
- [x] Idle inhibit toggle
- [x] Cava visualizer and media player
- [x] Power, Restart, Sleep, Lock buttons 
- [ ] Rename Zones and Modules to simple names
- [ ] Focus - Should be "Zone | Module", ex "Sliders and Toggles" if hovering, "Sliders and Toggles | Volume" if focused
- [ ] Make some modules not selectable, skippable since there is no interaction. Move them to the top
- [ ] Add padding under cava so border doesn't bleed into it
- [ ] Fix extra padding between bottom of control center and border when hovering over Power Center

**Jet: self-hosted services**
- [ ] Vaultwarden
- [ ] Forgejo

**Hardware**
- [ ] Adjust fan curves

---

## Acknowledgements

- [vimjoyer](https://www.youtube.com/@vimjoyer/videos) - YouTube channel that started this journey
- [anotherhadi/nixy](https://github.com/anotherhadi/nixy) - first configuration that made the structure click
- [mightyiam/infra](https://github.com/mightyiam/infra) - source of the dendritic pattern used throughout this repo

---

<p align="center">
    <i>See you space cowboy...</i>
</p>
