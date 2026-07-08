{config, ...}: let
  inherit (config.flake.meta.owner) username;
in {
  flake.modules.nixos.sunshine = {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
    users.users.${username}.extraGroups = ["uinput"];
    hardware.uinput.enable = true;
  };
}
