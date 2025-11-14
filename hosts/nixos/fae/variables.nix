{
  lib,
  config,
  ...
}: {
  options = {
    var = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };

  config.var = let
    username = "arturo";
    hostname = "fae";
    configPath = "/home/${username}/.config/nix-config";
  in {
    inherit username hostname configPath;
    profileImagePath = configPath + "/themes/profilepics/ein.jpg";
    pokemonSprite = "umbreon -s";

    monitors = {
      main = "ASUSTek COMPUTER INC XG27AQMR SALMTF054549";
      secondary = "LG Electronics LG ULTRAGEAR 107NTZN78013";
    };

    shell = "zsh"; # zsh or fish
    terminal = "ghostty";
    launcher = "rofi -show drun";
    browser = "zen";
    file-manager = "thunar";
  };
}
