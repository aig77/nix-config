{
  inputs,
  pkgs,
  ...
}: let
  inherit
    (inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system})
    hyprland
    xdg-desktop-portal-hyprland
    ;
in {
  programs.hyprland = {
    enable = true;
    package = hyprland;
    portalPackage = xdg-desktop-portal-hyprland;
  };

  # GUI Display Manager
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
}
