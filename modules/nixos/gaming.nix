{pkgs, ...}: {
  programs = {
    steam.enable = true;
    steam.gamescopeSession = {
      enable = true;
      args = [
        "-f"
        "-w 2560"
        "-h 1440"
        "--cursor-lock-enabled"
      ];
    };
    gamemode.enable = true;
  };

  environment.systemPackages = with pkgs; [
    mangohud
    protonup-qt
    lutris
    heroic
    bottles
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\\\${HOME}/.steam/root/compatibilitytools.d";
  };
}
