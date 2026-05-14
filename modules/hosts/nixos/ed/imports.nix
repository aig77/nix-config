{config, ...}: {
  configurations.nixos.ed.module = {
    imports = with config.flake.modules.nixos; [
      base
      tailscale
      dns
    ];
    nixpkgs.hostPlatform = "aarch64-linux";
  };
}
