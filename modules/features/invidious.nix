{inputs, ...}: {
  flake.modules.nixos.invidious = {
    config,
    pkgs,
    ...
  }: let
    companion = pkgs.stdenv.mkDerivation {
      name = "invidious-companion";
      src = inputs.invidious-companion;
      phases = ["unpackPhase" "installPhase"];
      installPhase = ''
        mkdir -p $out/bin
        cp invidious_companion $out/bin/
        chmod +x $out/bin/invidious_companion
      '';
    };
  in {
    sops.secrets = {
      invidious-hmac-key = {};
      invidious-extra-settings = {};
      invidious-companion-env = {};
    };

    services.invidious = {
      enable = true;
      package = pkgs.invidious.overrideAttrs (_: {src = inputs.invidious;});
      database.createLocally = true;
      address = "127.0.0.1";
      port = 3000;
      hmacKeyFile = config.sops.secrets.invidious-hmac-key.path;
      settings = {
        login_only = true;
        registration_enabled = false;
        invidious_companion = [
          {
            private_url = "http://127.0.0.1:8282";
          }
        ];
      };
      extraSettingsFile = config.sops.secrets.invidious-extra-settings.path;
    };

    systemd = {
      services = {
        invidious-companion = {
          description = "Invidious companion service";
          wantedBy = ["multi-user.target"];
          after = ["network.target"];
          serviceConfig = {
            ExecStart = "${companion}/bin/invidious_companion";
            EnvironmentFile = config.sops.secrets.invidious-companion-env.path;
            Restart = "on-failure";
            DynamicUser = true;
          };
        };

        # Rebuilds from the GitHub flake daily at 04:00, picking up any updated
        # invidious/invidious-companion flake inputs committed from the workstation.
        invidious-update = {
          description = "Daily invidious rebuild from latest flake";
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "/run/current-system/sw/bin/nixos-rebuild switch --flake github:<your-github-user>/bebop#jet";
          };
        };
      };

      timers.invidious-update = {
        description = "Daily invidious update timer";
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "04:00";
          Persistent = true;
        };
      };
    };
  };
}
