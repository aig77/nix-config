# AGENTS.md - Nix Configuration Repository Guide

## Build/Deploy Commands
- `nix develop` - Enter development shell with tools
- `nixos-rebuild switch --flake .#<hostname>` - Deploy NixOS config (spike, fae)
- `darwin-rebuild switch --flake .#ein` - Deploy macOS config
- `nix flake check` - Validate flake syntax and dependencies
- `nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel` - Build without deploying

## Fresh NixOS Installation (Remote via nixos-anywhere)
For fresh NixOS installations on machines like 'fae', use nixos-anywhere to install remotely from your Mac:

### Quick Start
1. **On target machine**: Boot NixOS installer ISO, enable SSH, get IP
   ```bash
   systemctl start sshd
   passwd  # Set root password
   ip a    # Get IP address
   ```

2. **From your Mac**: Run the install script
   ```bash
   ./hosts/fae/install.sh <target-ip> /dev/nvme0n1
   ```

### Manual nixos-anywhere Command
```bash
nix run github:nix-community/nixos-anywhere -- \
  --flake .#fae \
  --disk-device /dev/nvme0n1 \
  root@<target-ip>
```

This will:
- Partition and format the disk using disko configuration
- Install NixOS with your flake configuration
- Automatically reboot into the configured system

See `hosts/fae/disko.nix` for detailed installation instructions.

## Code Quality
- `alejandra .` - Format all Nix files (pre-commit hook enabled)
- `deadnix .` - Remove dead code (pre-commit hook enabled) 
- `statix check .` - Lint for best practices (pre-commit hook enabled)
- Pre-commit hooks run automatically on commit

## Code Style Guidelines
- Use `alejandra` formatter (2-space indentation, consistent style)
- Import order: `{pkgs, lib, config, inputs, ...}` with inputs at end
- Use `with pkgs;` for package lists, avoid elsewhere
- Use `let...in` blocks for complex expressions and color definitions
- Variable naming: `kebab-case` for attributes, `camelCase` for functions
- File structure: `imports` first, then options, then config
- Use `inherit` for passing through attributes: `inherit (config.lib.stylix) colors;`
- Comments: Use `#` for single line, avoid unless explaining complex logic
- String interpolation: `"${variable}"` preferred over concatenation