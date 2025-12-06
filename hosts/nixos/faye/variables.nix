{lib, ...}: {
  options = {
    var = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };

  config.var = let
    username = "arturo";
    hostname = "faye";
    configPath = "/home/${username}/.config/nix-config";
  in {
    inherit username hostname configPath;
    pokemonSprite = "umbreon -s";

    monitors = {
      main = "ASUSTek COMPUTER INC XG27AQMR SALMTF054549";
      secondary = "LG Electronics LG ULTRAGEAR 107NTZN78013";
    };

    shell = "zsh"; # zsh or fish
    terminal = "alacritty";
    browser = "zen";

    launcher = "rofi -show drun";
    file-manager = "thunar";
    lock = "hyprlock";
  };
}
