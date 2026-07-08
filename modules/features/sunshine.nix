{
  config,
  inputs,
  ...
}: let
  inherit (config.flake.meta.owner) username;
in {
  flake.modules.nixos.sunshine = {pkgs, ...}: let
    inherit (pkgs.stdenv.hostPlatform) system;
    hyprctl = "${inputs.hyprland.packages.${system}.hyprland}/bin/hyprctl";
    jq = "${pkgs.jq}/bin/jq";

    # Creates a virtual output sized to whatever Moonlight client connects and
    # disables the real monitor(s), so streaming doesn't depend on a physical
    # display being plugged in. Monitor names are discovered at runtime so this
    # works regardless of what's actually connected on a given host.
    headlessStart = pkgs.writeShellScript "sunshine-headless-start" ''
      set -euo pipefail
      for m in $(${hyprctl} monitors -j | ${jq} -r '.[] | select(.name | startswith("HEADLESS") | not) | .name'); do
        ${hyprctl} eval "hl.monitor({output=\"$m\", disabled=true})"
      done
      ${hyprctl} output create headless
      name=$(${hyprctl} monitors -j | ${jq} -r '[.[] | select(.name | startswith("HEADLESS"))][-1].name')
      ${hyprctl} eval "hl.monitor({output=\"$name\", mode=\"''${SUNSHINE_CLIENT_WIDTH}x''${SUNSHINE_CLIENT_HEIGHT}@''${SUNSHINE_CLIENT_FPS}\", position=\"auto\", scale=\"1\"})"
    '';

    headlessStop = pkgs.writeShellScript "sunshine-headless-stop" ''
      set -euo pipefail
      for m in $(${hyprctl} monitors -j | ${jq} -r '.[] | select(.name | startswith("HEADLESS")) | .name'); do
        ${hyprctl} output remove "$m"
      done
      ${hyprctl} reload
    '';
  in {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;

      applications = {
        apps = [
          {name = "Desktop";}
          {
            name = "Hyprland Headless";
            "prep-cmd" = [
              {
                do = "${headlessStart}";
                undo = "${headlessStop}";
              }
            ];
          }
        ];
      };
    };

    users.users.${username}.extraGroups = ["uinput"];
    hardware.uinput.enable = true;
  };
}
