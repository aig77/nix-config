_: {
  flake.modules.nixos.hyprland = {
    inputs,
    pkgs,
    ...
  }: let
    inherit (pkgs.stdenv.hostPlatform) system;
  in {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${system}.hyprland;
      portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
    };

    stylix.targets.hyprland.enable = false;
  };

  flake.modules.homeManager.hyprland = {pkgs, ...}: {
    home.packages = with pkgs; [
      hyprpolkitagent
    ];
  };
}
