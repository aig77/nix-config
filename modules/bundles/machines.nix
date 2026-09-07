{config, ...}: let
  inherit (config.flake.meta.owner) username;
  hm = config.flake.modules.homeManager;
  inherit (config.flake.modules) nixos;
in {
  flake.modules.nixos = {
    desktop = _: {
      imports = with nixos; [
        audio
        bluetooth
        desktop-extras
        grub
        theme
        thunar
      ];
      home-manager.users.${username} = {
        imports = with hm; [gui];
        home.packages = [];
      };
    };

    laptop = _: {
      imports = with nixos; [
        desktop
        protonvpn
      ];
      services.keyd = {
        enable = true;
        keyboards.default = {
          ids = ["*"];
          settings.main = {
            rightcontrol = "rightmeta";
          };
        };
      };
    };

    htpc = _: {
      imports = with nixos; [
        audio
        bluetooth
        desktop-extras
        grub
        theme
      ];
      home-manager.users.${username}.imports = with hm; [
        bitwarden
        discord
        shell-lite
        zen
      ];
      # USB keyboard+touchpad combo support (e.g. Rii mini); libinput explicit for Jovian Wayland
      boot.kernelModules = ["hid_generic"];
      services.libinput.enable = true;
    };

    server = {lib, ...}: {
      imports = with nixos; [healthchecks];
      services.getty.autologinUser = username;
      home-manager.users.${username}.imports = [hm.shell-lite];
      sops.age.keyFile = lib.mkForce "/etc/sops/age/keys.txt";
    };
  };
}
