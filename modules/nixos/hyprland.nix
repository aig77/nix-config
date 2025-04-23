{ inputs, pkgs, ... }: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    #withUWSM = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [ "gtk" "hyprland" ];
    };
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

}

