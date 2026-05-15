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
    };

    server = _: {
      services.getty.autologinUser = config.var.username;
      home-manager.users.${username}.imports = [hm.shell-lite];
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
