{inputs, ...}: {
  flake.modules.nixos.invidious = {
    config,
    pkgs,
    ...
  }: let
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
    sops.secrets.invidious-companion-key = {};

    sops.templates."invidious-companion-settings.json" = {
      mode = "0444";
      content = ''
        {"invidious_companion":[{"private_url":"http://127.0.0.1:8282/companion"}],"invidious_companion_key":"${config.sops.placeholder."invidious-companion-key"}"}
      '';
    };

    sops.templates."invidious-companion.env" = {
      mode = "0444";
      content = ''
        SERVER_SECRET_KEY=${config.sops.placeholder."invidious-companion-key"}
      '';
    };

    services.invidious = {
      enable = true;
      package = pkgs.invidious.overrideAttrs (_: {src = inputs.invidious; doCheck = false;});
      database.createLocally = true;
      address = "0.0.0.0";
      port = 3000;
      settings = {
        login_only = true;
        registration_enabled = false;
      };
      extraSettingsFile = config.sops.templates."invidious-companion-settings.json".path;
    };

    programs.nix-ld.enable = true;

    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [3000];

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

        # Rebuilds from the GitHub flake daily at 04:00, picking up any updated
        # invidious/invidious-companion flake inputs committed from the workstation.
        invidious-update = {
          description = "Daily invidious rebuild from latest flake";
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "/run/current-system/sw/bin/nixos-rebuild switch --flake github:aig77/bebop#jet";
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
