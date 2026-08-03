{config, ...}: let
  inherit (config.flake.modules) nixos darwin;
in {
  flake.modules.nixos.base = {
    imports = with nixos; [tailscale];
  };

  flake.modules.darwin.base = {
    imports = with darwin; [tailscale];
  };
}
