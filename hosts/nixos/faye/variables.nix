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

    location = "Miami";

    shell = "zsh"; # zsh or fish
    terminal = "ghostty";
    browser = "zen";

    launcher = "rofi -show drun";
    file-manager = "thunar";
    lock = "hyprlock";
  };
}
