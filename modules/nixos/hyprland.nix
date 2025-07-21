{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    #withUWSM = true;
    #package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    #portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  xdg.portal = {
    enable = true;
    config.common.default = "hyprland";
    extraPortals = with pkgs; [
      #xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      #inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
    ];
  };
}
