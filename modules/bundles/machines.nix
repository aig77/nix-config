{config, ...}: let
  inherit (config.flake.meta.owner) username;
  hm = config.flake.modules.homeManager;
  inherit (config.flake.modules) nixos;
in {
  flake.modules.nixos = {
    desktop = _: {
      imports = with nixos; [audio bluetooth desktop-extras grub theme thunar];
      home-manager.users.${username}.imports = with hm; [
        eyecandy-nixos
        gui
        shell

        obs
        obsidian
        spotify
        zathura
        zen
      ];
    };

    laptop = _: {
      imports = with nixos; [audio bluetooth desktop-extras grub theme thunar];
      home-manager.users.${username}.imports = with hm; [eyecandy-nixos gui shell];
    };

    htpc = _: {
      imports = with nixos; [audio bluetooth desktop-extras grub theme thunar];
      home-manager.users.${username}.imports = with hm; [gui shell-lite];

      # USB keyboard+touchpad combo support (e.g. Rii mini); libinput explicit for Jovian Wayland
      boot.kernelModules = ["hid_generic"];
      services.libinput.enable = true;
    };

    server = {lib, ...}: {
      services.getty.autologinUser = username;
      home-manager.users.${username}.imports = [hm.shell-lite];
      sops.age.keyFile = lib.mkForce "/etc/sops/age/keys.txt";
    };

    desktop-extras = _: {
      services = {
        xserver = {
          enable = true;
          xkb.layout = "us";
          xkb.variant = "";
        };
        gnome.gnome-keyring.enable = true;
        printing.enable = true;
      };
      security.polkit.enable = true;
    };
  };
}
