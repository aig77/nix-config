{ pkgs, config, inputs, ... }:
let
  sddm-astronaut = pkgs.sddm-astronaut.override {
    themeConfig = {
      Background = "${toString config.stylix.image}";
      Font = "JetBrainsMono Nerd Font";
    };
  };
in {
  services.displayManager = {
    sddm = {
      enable = true;
      package = pkgs.kdePackages.sddm;
      extraPackages = [ sddm-astronaut ];
      theme = "sddm-astronaut-theme";
      wayland.enable = true;
      settings = {
        Wayland.SessionDir = "${
            inputs.hyprland.packages."${pkgs.system}".hyprland
          }/share/wayland-sessions";
      };
    };
  };
  environment.systemPackages = [ sddm-astronaut ];

  # To prevent getting stuck at shutdown
  systemd.extraConfig = "DefaultTimeoutStopSec=10s";
}
