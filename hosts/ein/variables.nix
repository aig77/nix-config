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

  config.var = {
    hostname = "macbook";
    username = "arturo";
    configDirectory = "/home/" + config.var.username + "./config/nix";

    git = {
      username = "aig77";
      email = "";
    };

    terminal = "ghostty";
    browser = "zen";
  };
}
