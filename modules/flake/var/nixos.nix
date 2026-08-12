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
          # 3. Cross-machine services. Add a `host` field (default
          #    "localhost"). caddy.nix's reverse_proxy and cloudflared.nix's
          #    ingress both hardcode `localhost:${port}`, assuming the
          #    service is co-located with Caddy; monitor.host (gatus/glance)
          #    is already overridable but the routing layer isn't. Thread
          #    `host` through both so a service on a separate VM/host can be
          #    registered and actually reached, not just health-checked.
          # 4. Per-service servePort. Add `servePort` (nullOr port, default
          #    null) so a private service can claim a custom HTTPS port for
          #    tailscale serve (glance uses 443). tailscale.nix drops its
          #    glance special case for a uniform serveCmd builder; glance.nix's
          #    URL builder honors servePort.
          # TODO: LAN topology registry. Add `network` (subnet + per-host
          # IPv4s, e.g. { subnet = "192.168.68.0/24"; hosts.ed = "..." }) so
          # gatus.nix, prometheus.nix, and tailscale.nix stop hardcoding
          # 192.168.68.101. Hosts declare their own IP in variables.nix.
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
