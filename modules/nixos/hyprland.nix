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

  # TUI Display Manager
  # services.displayManager.lemurs = {
  #   enable = true;
  #   settings = {
  #     wayland = {
  #       # Override the wayland sessions path to use our custom one
  #       wayland_sessions_path = "/etc/wayland-sessions-lemurs";
  #     };
  #   };
  # };
  #
  # environment.etc."wayland-sessions-lemurs/hyprland.desktop".text = ''
  #   [Desktop Entry]
  #   Name=Hyprland
  #   Comment=An intelligent dynamic tiling Wayland compositor
  #   Exec=${hyprland}/bin/start-hyprland
  #   Type=Application
  # '';
}
