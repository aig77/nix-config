{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # TODO(nixpkgs-tracking): per-host nixpkgs selection, two phases.
    # Phase 1 machine-wide: servers (jet, ed) build from nixos-26.05 stable, desktops
    # (ein, spike, faye) stay on nixos-unstable. Add nixpkgs-stable input, select per host via
    # configurations.nixos.<name>.nixpkgs in modules/flake/nixosConfigurations.nix, and enforce
    # servers -> stable with a role assertion.
    # Phase 2 per-package: layer targeted unstable overrides (unstablePkgs overlay) on stable
    # hosts only, for services that need newer than stable.
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    caelestia = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-desktop = {
      url = "github:aaddrick/claude-desktop-debian";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    daily-stoic = {
      url = "github:aig77/daily-stoic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    grub2-themes.url = "github:vinceliuice/grub2-themes";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jovian-nixos.url = "github:Jovian-Experiments/Jovian-NixOS";

    nixos-anywhere = {
      url = "github:nix-community/nixos-anywhere";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.disko.follows = "disko";
    };

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

    mac-app-util.url = "github:hraban/mac-app-util";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;}
    (inputs.import-tree ./modules);
}
