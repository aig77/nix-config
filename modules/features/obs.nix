_: {
  flake.modules.homeManager.obs = {
    pkgs,
    lib,
    ...
  }:
    lib.mkIf pkgs.stdenv.isLinux {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          obs-pipewire-audio-capture
        ];
      };
    };
}
