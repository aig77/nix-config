{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    # ./sddm.nix  # Commented out - using GDM instead
    ./gdm.nix
  ];

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
}
