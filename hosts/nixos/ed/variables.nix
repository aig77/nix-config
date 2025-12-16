{lib, ...}: {
  options = {
    var = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };

  config.var = let
    username = "arturo";
    hostname = "ed";
    configPath = "/home/${username}/.config/nix-config";
  in {
    inherit username hostname configPath;

    shell = "zsh"; # zsh or fish
  };
}
