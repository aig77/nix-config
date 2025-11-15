{
  pkgs,
  config,
  inputs,
  ...
}: let
  sddm-astronaut = pkgs.sddm-astronaut.override {
    themeConfig = {
      Background = config.stylix.image;
      Font = config.stylix.fonts.monospace.name;
    };
  };
in {
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;
      extraPackages = [sddm-astronaut];
      theme = "sddm-astronaut-theme";
      settings = {
        Wayland.SessionDir = "${
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
        }/share/wayland-sessions";
      };
    };
  };
  environment.systemPackages = [sddm-astronaut];
}
