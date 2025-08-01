{
  config,
  lib,
  ...
}: {
  imports = [../../themes];

  options = {
    var = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };

  config.var = {
    hostname = "nixos";
    username = "arturo";
    configDirectory = "/home/" + config.var.username + "/nix";
    configName = "thinkpad";

    git = {
      username = "aig77";
      email = "";
    };

    terminal = "ghostty";
    launcher = "rofi -show drun";
    lock = "hyprlock";
    logout = "wlogout";
    browser = "zen";
    file-manager = "thunar";
  };
}
