{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [../../themes/macbook.nix];

  options = {
    var = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };

  config.var = let
    username = "arturo";
    hostname = "ein";
    configPath = "/home/${username}/.config/nix-config";
    {
    inherit username hostname configPath;
    profileImagePath = configPath + "/themes/profilepics/ein.jpg";

    git = {
      username = "aig77";
      email = "";
    };

    terminal = "ghostty";
    browser = "zen";
  };
}
