{lib, ...}: {
  options.var = lib.mkOption {
    type = lib.types.submodule {
      options = {
        username = lib.mkOption {type = lib.types.str;};
        hostname = lib.mkOption {type = lib.types.str;};
        location = lib.mkOption {type = lib.types.str;};
        shell = lib.mkOption {type = lib.types.enum ["zsh" "fish"];};
        terminal = lib.mkOption {type = lib.types.enum ["alacritty" "ghostty"];};
        browser = lib.mkOption {type = lib.types.enum ["zen"];};
        launcher = lib.mkOption {type = lib.types.enum ["rofi" "fuzzel"];};
        fileManager = lib.mkOption {type = lib.types.enum ["thunar"];};
        lock = lib.mkOption {type = lib.types.enum ["hyprlock"];};
        logout = lib.mkOption {type = lib.types.enum ["wlogout"];};
      };
    };
    default = {};
  };

  config.var = {
    username = "arturo";
    hostname = "faye";
    location = "Miami";

    shell = "zsh";

    terminal = "ghostty";
    browser = "zen";
    launcher = "fuzzel";
    fileManager = "thunar";
    lock = "hyprlock";
    logout = "wlogout";
  };
}
