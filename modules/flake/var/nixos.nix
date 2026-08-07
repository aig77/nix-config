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
          # 3. Monitoring + homepage registration. Two separate submodules:
          #    - monitor (nullOr { type = enum ["http" "tcp"]; host default
          #      "localhost"; path default "/" (http only); conditions
          #      listOf str, default ["[STATUS] == 200"] for http /
          #      ["[CONNECTED] == true"] for tcp; }). gatus.nix filters
          #      services on monitor != null and builds tcp://host:port or
          #      http://host:port+path off `type`.
          #    - homepage (nullOr { icon = str; title = nullOr str, default
          #      null; }). Opt-in to the glance dashboard. glance.nix filters
          #      on homepage != null (asserting monitor.type == "http", since
          #      its check-url widget has no tcp probe), reuses `public` to
          #      pick the group (Public/Private Services) and URL template
          #      (subdomain.$SERVICE_DOMAIN vs $TAILSCALE_HOST:port), and
          #      falls back to a capitalized service name when title is null.
          #    Replaces the hand-written gatus/glance entries per service.
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
