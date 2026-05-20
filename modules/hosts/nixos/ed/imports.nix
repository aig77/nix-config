{config, ...}: {
  configurations.nixos.ed.module = {
    imports = with config.flake.modules.nixos; [
      base
      server
      tailscale
      prometheus-client
      dns
    ];
    nixpkgs.hostPlatform = "aarch64-linux";
    nix.settings.filter-syscalls = false;
  };
}
