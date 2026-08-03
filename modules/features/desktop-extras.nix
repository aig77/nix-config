# Required setups with a desktop
_: {
  flake.modules.nixos.desktop-extras = _: {
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
}
