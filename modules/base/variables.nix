{
  flake.nixosModules.variables = {lib, ...}: {
    options.var = lib.mkOption {
      type = lib.types.submodule {
        options = {
          username = lib.mkOption {type = lib.types.str;};
          hostname = lib.mkOption {type = lib.types.str;};
          location = lib.mkOption {
            type = lib.types.str;
            default = "";
          };
          shell = lib.mkOption {
            type = lib.types.enum ["zsh" "fish"];
            default = "zsh";
          };
          terminal = lib.mkOption {
            type = lib.types.enum ["alacritty" "ghostty"];
            default = "ghostty";
          };
          browser = lib.mkOption {
            type = lib.types.enum ["zen"];
            default = "zen";
          };
          launcher = lib.mkOption {
            type = lib.types.enum ["rofi" "fuzzel"];
            default = "fuzzel";
          };
          fileManager = lib.mkOption {
            type = lib.types.enum ["nautilus"];
            default = "nautilus";
          };
          lock = lib.mkOption {
            type = lib.types.enum ["hyprlock"];
            default = "hyprlock";
          };
          logout = lib.mkOption {
            type = lib.types.enum ["wlogout"];
            default = "wlogout";
          };
        };
      };
      default = {};
    };
  };
}
