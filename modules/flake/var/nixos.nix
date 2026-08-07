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
            type = lib.types.enum ["waybar" "hyprpanel" "quickshell" "caelestia" "noctalia"];
            default = "waybar";
          };
          fileManager = lib.mkOption {
            type = lib.types.enum ["nautilus" "thunar"];
            default = "thunar";
          };
          # TODO: var.services schema improvements:
          # 1. Exposure-gated config. subdomain/auth only apply when public.
          #    Replace public/subdomain/auth with an `expose` submodule
          #    (nullOr { subdomain; auth; }): private services drop dead
          #    subdomain/auth fields; consumers filter on expose != null.
          # 2. Typed db backups. Add backup.database submodule
          #    (enum postgres/sqlite + name/path); backup.nix generates the
          #    pg_dump/sqlite3 prepareCommand and appends the dump file to
          #    restic paths. Covers invidious, forgejo (postgres), daily-stoic,
          #    vaultwarden, subtrakr (sqlite).
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
                monitor = lib.mkOption {
                  type = lib.types.submodule ({config, ...}: {
                    options = {
                      enable = lib.mkOption {
                        type = lib.types.bool;
                        default = false;
                      };
                      type = lib.mkOption {
                        type = lib.types.enum ["http" "tcp"];
                        default = "http";
                      };
                      host = lib.mkOption {
                        type = lib.types.str;
                        default = "localhost";
                      };
                      path = lib.mkOption {
                        type = lib.types.str;
                        default = "/";
                      };
                      conditions = lib.mkOption {
                        type = lib.types.listOf lib.types.str;
                        default =
                          if config.type == "http"
                          then ["[STATUS] == 200"]
                          else ["[CONNECTED] == true"];
                      };
                      interval = lib.mkOption {
                        type = lib.types.str;
                        default = "5m";
                      };
                      failureThreshold = lib.mkOption {
                        type = lib.types.int;
                        default = 2;
                      };
                      successThreshold = lib.mkOption {
                        type = lib.types.int;
                        default = 1;
                      };
                    };
                  });
                  default = {};
                };
                homepage = lib.mkOption {
                  type = lib.types.submodule {
                    options = {
                      enable = lib.mkOption {
                        type = lib.types.bool;
                        default = false;
                      };
                      title = lib.mkOption {
                        type = lib.types.nullOr lib.types.str;
                        default = null;
                      };
                      icon = lib.mkOption {
                        type = lib.types.str;
                        default = "";
                      };
                    };
                  };
                  default = {};
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
