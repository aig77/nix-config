{lib, ...}: {
  options.var = lib.mkOption {
    type = lib.types.submodule {
      options = {
        username = lib.mkOption {type = lib.types.str;};
        hostname = lib.mkOption {type = lib.types.str;};
        location = lib.mkOption {type = lib.types.str;};
        desktop = lib.mkOption {type = lib.types.enum ["gnome" "hyprland" "niri" "none"];};
        shell = lib.mkOption {type = lib.types.enum ["zsh" "fish"];};
        terminal = lib.mkOption {type = lib.types.enum ["alacritty" "ghostty"];};
        browser = lib.mkOption {type = lib.types.enum ["zen"];};
        launcher = lib.mkOption {type = lib.types.enum ["rofi"];};
        fileManager = lib.mkOption {type = lib.types.enum ["thunar"];};
        lock = lib.mkOption {type = lib.types.enum ["hyprlock"];};
      };
    };
    default = {};
  };

  config.var = {
    username = "arturo";
    hostname = "faye";
    location = "Miami";

    desktop = "hyprland";
    shell = "zsh";

    terminal = "ghostty";
    browser = "zen";
    launcher = "rofi";
    fileManager = "thunar";
    lock = "hyprlock";
  };
}
