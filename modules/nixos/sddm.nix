{ pkgs, inputs, ... }:

{
  services.displayManager = {
    sddm = {
      package = pkgs.kdePackages.sddm;
      #extraPackages = [ sddm-astronaut ];
      enable = true;
      wayland.enable = true;
      #theme = "sddm-astronaut-theme";
      settings = {
        Wayland.SessionDir = "${
          inputs.hyprland.packages."${pkgs.system}".hyprland
        }/share/wayland-sessions";
      };
    };
  };
}

