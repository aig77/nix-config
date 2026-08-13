_: {
  flake.modules.nixos.glance = {
    config,
    lib,
    ...
  }: let
    mkSite = name: svc: let
      title =
        if svc.homepage.title != null
        then svc.homepage.title
        else lib.toUpper (lib.substring 0 1 name) + lib.substring 1 (-1) name;
      checkUrl =
        if svc.monitor.type == "http"
        then "http://${svc.monitor.host}:${toString svc.port}${svc.monitor.path}"
        else "http://${svc.monitor.host}:${toString svc.port}";
    in {
      inherit title;
      url =
        if svc.public
        then "https://${svc.subdomain}.\${SERVICE_DOMAIN}"
        else if svc.servePort == null
        then "https://\${TAILSCALE_HOST}:${toString svc.port}"
        else if svc.servePort == 443
        then "https://\${TAILSCALE_HOST}"
        else "https://\${TAILSCALE_HOST}:${toString svc.servePort}";
      "check-url" = checkUrl;
      icon = svc.homepage.icon;
    };

    homepageServices = lib.filterAttrs (_: s: s.homepage.enable) config.var.services;
    publicSites = lib.mapAttrsToList mkSite (lib.filterAttrs (_: s: s.public) homepageServices);
    privateSites = lib.mapAttrsToList mkSite (lib.filterAttrs (_: s: !s.public) homepageServices);
  in {
    var.services.glance = {
      subdomain = "glance";
      port = config.ports.glance;
      servePort = 443;
      public = false;
      auth = false;
    };

    sops = {
      secrets = {
        "tailscale/tailnet" = {};
        "cloudflare/service-domain" = {};
      };
      templates."glance.env" = {
        content = ''
          TAILSCALE_HOST=${config.var.hostname}.${config.sops.placeholder."tailscale/tailnet"}
          SERVICE_DOMAIN=${config.sops.placeholder."cloudflare/service-domain"}
        '';
      };
    };

    services.glance = {
      enable = true;
      settings = {
        server = {
          port = config.ports.glance;
          host = "127.0.0.1";
        };

        branding = {
          "logo-text" = "🎷";
        };

        theme = {
          "background-color" = "240 21% 15%";
          "primary-color" = "217 92% 76%";
          "positive-color" = "115 54% 76%";
          "negative-color" = "343 81% 75%";
        };

        pages = [
          {
            name = "Home";
            columns = [
              {
                size = "small";
                widgets = [
                  {
                    type = "clock";
                    "hour-format" = "12h";
                  }
                  {
                    type = "calendar";
                    "first-day-of-week" = "monday";
                  }
                  {
                    type = "rss";
                    limit = 10;
                    "collapse-after" = 3;
                    cache = "12h";
                    feeds = [
                      {
                        url = "https://www.cnbc.com/id/10000664/device/rss/rss.html";
                        title = "CNBC Markets";
                      }
                      {url = "https://selfh.st/rss/";}
                      {url = "https://this-week-in-rust.org/rss.xml";}
                      {url = "https://weekly.nixos.org/feeds/all.rss.xml";}
                      {url = "https://samwho.dev/rss.xml";}
                      {url = "https://www.jeffgeerling.com/blog.xml";}
                    ];
                  }
                ];
              }
              {
                size = "full";
                widgets = [
                  {
                    type = "search";
                    "search-engine" = "https://search.brave.com/search?q={QUERY}";
                    "new-tab" = true;
                  }
                  {
                    type = "group";
                    widgets = [
                      {type = "hacker-news";}
                      {type = "lobsters";}
                      {
                        type = "reddit";
                        subreddit = "programming";
                        "show-thumbnails" = true;
                      }
                    ];
                  }
                  {
                    type = "videos";
                    cache = "1h";
                    channels = [
                      "UC8ENHE5xdFSwx71u3fDH5Xw"
                      "UCd3dNckv1Za2coSaHGHl5aA"
                      "UC6biysICWOJ-C3P4Tyeggzg"
                      "UC65_CVnMw6hvPET_DRDg3GA"
                    ];
                  }
                  {
                    type = "group";
                    widgets = [
                      {
                        type = "reddit";
                        subreddit = "selfhosted";
                        "show-thumbnails" = true;
                      }
                      {
                        type = "reddit";
                        subreddit = "nixos";
                        "show-thumbnails" = true;
                      }
                      {
                        type = "reddit";
                        subreddit = "stocks";
                        "show-thumbnails" = true;
                      }
                      {
                        type = "reddit";
                        subreddit = "rust";
                        "show-thumbnails" = true;
                      }
                      {
                        type = "reddit";
                        subreddit = "linux_gaming";
                        "show-thumbnails" = true;
                      }
                    ];
                  }
                ];
              }
              {
                size = "small";
                widgets = [
                  {
                    type = "weather";
                    location = "Miami, United States";
                    units = "imperial";
                    "hour-format" = "12h";
                  }
                  {
                    type = "markets";
                    markets = [
                      {
                        symbol = "SPY";
                        name = "S&P 500";
                      }
                      {
                        symbol = "^TNX";
                        name = "10Y Treasury";
                      }
                      {
                        symbol = "^VIX";
                        name = "VIX";
                      }
                      {
                        symbol = "VTI";
                        name = "Total Market";
                      }
                      {
                        symbol = "DX-Y.NYB";
                        name = "USD Index";
                      }
                      {
                        symbol = "BTC-USD";
                        name = "Bitcoin";
                      }
                    ];
                  }
                  {
                    type = "releases";
                    cache = "1d";
                    limit = 5;
                    repositories = [
                      "actualbudget/actual"
                      "aristocratos/btop"
                      "caddyserver/caddy"
                      "cloudflare/cloudflared"
                      "dani-garcia/vaultwarden"
                      "danth/stylix"
                      "ghostty-org/ghostty"
                      "glanceapp/glance"
                      "grafana/grafana"
                      "hyprwm/Hyprland"
                      "iv-org/invidious"
                      "jesseduffield/lazygit"
                      "Mic92/sops-nix"
                      "neovim/neovim"
                      "nix-community/home-manager"
                      "YaLTeR/niri"
                      "NixOS/nixpkgs"
                      "tailscale/tailscale"
                      "TwiN/gatus"
                      "zen-browser/desktop"
                    ];
                  }
                ];
              }
            ];
          }
          {
            name = "Homelab";
            columns = [
              {
                size = "full";
                widgets = [
                  {
                    type = "monitor";
                    title = "Public Services";
                    cache = "1m";
                    sites = publicSites;
                  }
                  {
                    type = "monitor";
                    title = "Private Services";
                    cache = "1m";
                    sites = privateSites;
                  }
                ];
              }
            ];
          }
        ];
      };
    };

    systemd.services.glance.serviceConfig.EnvironmentFile = lib.mkForce config.sops.templates."glance.env".path;
  };
}
