{config, ...}: let
  inherit (config.flake.meta.owner) username;
  hm = config.flake.modules.homeManager;
in {
  flake.modules = {
    homeManager.eyecandyBase = {pkgs, ...}: {
      imports = with hm; [fastfetch fetchGreeting];
      home.packages = with pkgs; [
        krabby
        cmatrix
        pipes-rs
        cbonsai
        asciiquarium
        lavat
        lolcat
        sl
        nms
      ];
    };

    homeManager.eyecandyNixos = {pkgs, ...}: {
      imports = with hm; [fastfetch fetchGreeting cava];
      home.packages = with pkgs; [
        krabby
        cmatrix
        pipes-rs
        cbonsai
        asciiquarium
        lavat
        lolcat
        sl
        nms
        tty-clock
      ];
    };

    darwin.eyecandy = _: {
      home-manager.users.${username}.imports = [hm.eyecandyBase];
    };
  };
}
