{inputs, lib, ...}: {
  flake.modules.nixos.invidious = {
    config,
    pkgs,
    ...
  }: let
    # TODO: remove this override once nixpkgs gatus >= 5.36.0 (custom-css support)
    # When that lands, delete the gatus input in flake.nix, this let block, and
    # switch ExecStart back to ${pkgs.gatus}/bin/gatus.
    gatus = pkgs.buildGoModule {
      pname = "gatus";
      version = "master";
      src = inputs.gatus;
      vendorHash = "sha256-RbFNtojZthf7bKMhGStH/jOkeIR6EHpw2vvAMLEFtKI=";
      subPackages = ["."];
    };
    companion = pkgs.stdenv.mkDerivation {
      name = "invidious-companion";
      src = inputs.invidious-companion;
      nativeBuildInputs = [pkgs.autoPatchelfHook];
      buildInputs = [pkgs.stdenv.cc.cc.lib pkgs.openssl];
      phases = ["unpackPhase" "installPhase"];
      installPhase = ''
        mkdir -p $out/bin
        cp invidious_companion $out/bin/invidious_companion
        chmod +x $out/bin/invidious_companion
      '';
    };
  in {
    var.services = {
      invidious = {
        subdomain = "invidious";
        port = config.ports.invidious;
        public = true;
        auth = true;
      };
      invidious-status = {
        subdomain = "invidious-status";
        port = config.ports.invidiousStatus;
        public = true;
        auth = false;
      };
    };

    sops = {
      secrets."invidious/companion-key" = {};

      templates."invidious-companion-settings.json" = {
        mode = "0444";
        content = ''
          {"invidious_companion":[{"private_url":"http://127.0.0.1:${toString config.ports.invidiousCompanion}/companion"}],"invidious_companion_key":"${config.sops.placeholder."invidious/companion-key"}","https_only":true,"domain":"invidious.${config.sops.placeholder."cloudflare/service-domain"}"}
        '';
      };

      templates."invidious-companion.env" = {
        mode = "0444";
        content = ''
          SERVER_SECRET_KEY=${config.sops.placeholder."invidious/companion-key"}
          PORT=${toString config.ports.invidiousCompanion}
        '';
      };
    };

    programs.nix-ld.enable = true;

    services.invidious = {
      enable = true;
      package = pkgs.invidious.overrideAttrs (_: {
        src = inputs.invidious;
        doCheck = false;
      });
      database.createLocally = true;
      address = "127.0.0.1";
      port = config.ports.invidious;
      extraSettingsFile = config.sops.templates."invidious-companion-settings.json".path;
    };

    sops.secrets."cloudflare/service-domain" = {};

    sops.templates."gatus-invidious.yaml" = {
      mode = "0444";
      content = ''
        web:
          port: ${toString config.ports.invidiousStatus}
        storage:
          type: sqlite
          path: /var/lib/gatus-invidious/data.db
        ui:
          title: Invidious Health Dashboard
          header: invidious.${config.sops.placeholder."cloudflare/service-domain"}
          dashboard-heading: Invidious Status
          dashboard-subheading: Is my Invidious instance up?
          logo: https://invidious.io/invidious-colored-vector.svg
          link: https://invidious.${config.sops.placeholder."cloudflare/service-domain"}
          buttons:
            - name: Open Invidious
              link: https://invidious.${config.sops.placeholder."cloudflare/service-domain"}
          custom-css: |
            #global {
              background-color: #121212;
              color: #efefef;
            }
            #global .dashboard-container {
              background-color: #121212;
            }
            #global .endpoint, #global .endpoint-group {
              background-color: #1e1e2e;
              border: 1px solid #2a2a2a;
            }
            #global .endpoint-header, #global .endpoint-group-header {
              background-color: #181825;
              color: #cdd6f4;
            }
            #global .endpoint-content, #global .endpoint-group-content {
              background-color: #1e1e2e;
              color: #cdd6f4;
            }
            #global a { color: #f14336; }
            #global a:hover { color: #ff6659; }
        endpoints:
          - name: Invidious
            url: http://localhost:${toString config.ports.invidious}/api/v1/stats
            interval: 5m
            conditions:
              - "[STATUS] == 200"
          - name: YouTube API
            url: http://localhost:${toString config.ports.invidious}/api/v1/trending
            interval: 15m
            conditions:
              - "[STATUS] == 200"
              - "[BODY] != []"
      '';
    };

    systemd = {
      services = {
        invidious-companion = {
          description = "Invidious companion service";
          wantedBy = ["multi-user.target"];
          after = ["network.target"];
          serviceConfig = {
            ExecStart = "${companion}/bin/invidious_companion";
            EnvironmentFile = config.sops.templates."invidious-companion.env".path;
            Restart = "on-failure";
            DynamicUser = true;
          };
        };

        gatus-invidious = {
          description = "Invidious public status page";
          wantedBy = ["multi-user.target"];
          after = ["network.target"];
          serviceConfig = {
            ExecStart = "${gatus}/bin/gatus";
            Environment = "GATUS_CONFIG_PATH=${config.sops.templates."gatus-invidious.yaml".path}";
            StateDirectory = "gatus-invidious";
            DynamicUser = true;
            Restart = "on-failure";
          };
        };

        invidious-update = {
          description = "Invidious rebuild from latest flake";
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "/run/current-system/sw/bin/nixos-rebuild switch --flake github:aig77/bebop#jet --refresh";
          };
        };

        invidious-monitor = {
          description = "Invidious health monitor - triggers update on extended downtime";
          serviceConfig = {
            Type = "oneshot";
            StateDirectory = "invidious-monitor";
            ExecStart = pkgs.writeShellScript "invidious-monitor" ''
              PORT=${toString config.ports.invidious}
              DOWNTIME_FILE=/var/lib/invidious-monitor/down-since

              stats_ok() {
                ${pkgs.curl}/bin/curl -sf --max-time 10 \
                  "http://localhost:$PORT/api/v1/stats" > /dev/null 2>&1
              }

              trending_ok() {
                BODY=$(${pkgs.curl}/bin/curl -sf --max-time 10 \
                  "http://localhost:$PORT/api/v1/trending" 2>/dev/null)
                [ $? -eq 0 ] && [ "$BODY" != "[]" ] && [ -n "$BODY" ]
              }

              if stats_ok && trending_ok; then
                rm -f "$DOWNTIME_FILE"
              else
                if [ -f "$DOWNTIME_FILE" ]; then
                  DOWN_SINCE=$(cat "$DOWNTIME_FILE")
                  NOW=$(${pkgs.coreutils}/bin/date +%s)
                  DIFF=$((NOW - DOWN_SINCE))
                  if [ "$DIFF" -ge 600 ]; then
                    systemctl --no-block start invidious-update
                    rm -f "$DOWNTIME_FILE"
                  fi
                else
                  ${pkgs.coreutils}/bin/date +%s > "$DOWNTIME_FILE"
                fi
              fi
            '';
          };
        };
      };

      timers.invidious-monitor = {
        description = "Invidious health check every 5 minutes";
        wantedBy = ["timers.target"];
        timerConfig = {
          OnBootSec = "5m";
          OnUnitActiveSec = "5m";
        };
      };
    };
  };
}
