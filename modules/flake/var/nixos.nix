{lib, ...}: {
  flake.modules.nixos.base = {
    options.var = lib.mkOption {
      type = lib.types.submodule ({config, ...}: {
        options = {
          username = lib.mkOption {type = lib.types.str;};
          hostname = lib.mkOption {type = lib.types.str;};
          git = lib.mkOption {
            type = lib.types.submodule {
              options = {
                name = lib.mkOption {
                  type = lib.types.str;
                  default = "";
                };
                email = lib.mkOption {
                  type = lib.types.str;
                  default = "";
                };
              };
            };
            default = {};
          };
          repoPath = lib.mkOption {
            type = lib.types.str;
            default = "/home/${config.username}/.config/bebop";
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
          location = lib.mkOption {
            type = lib.types.str;
            default = "";
          };
          desktop = lib.mkOption {
            type = lib.types.enum ["waybar" "hyprpanel" "quickshell" "caelestia"];
            default = "waybar";
          };
          fileManager = lib.mkOption {
            type = lib.types.enum ["nautilus" "thunar"];
            default = "thunar";
          };
          wallpaperEngine = lib.mkOption {
            type = lib.types.enum ["awww" "wallpaperengine"];
            default = "awww";
          };
          wallpaperPath = lib.mkOption {
            type = lib.types.str;
            default = "$HOME/.cache/bebop/current-wallpaper";
          };
          services = lib.mkOption {
            type = lib.types.attrsOf (lib.types.submodule {
              options = {
                subdomain = lib.mkOption {type = lib.types.str;};
                port = lib.mkOption {type = lib.types.port;};
                public = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                };
                auth = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                };
                backup = lib.mkOption {
                  type = lib.types.nullOr (lib.types.submodule {
                    options = {
                      paths = lib.mkOption {
                        type = lib.types.listOf lib.types.str;
                      };
                      prepareCommand = lib.mkOption {
                        type = lib.types.nullOr lib.types.str;
                        default = null;
                      };
                    };
                  });
                  default = null;
                };
              };
            });
            default = {};
          };
        };
      });
      default = {};
    };
  };
}
