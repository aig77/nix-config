{ pkgs, ... }: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };

  imports = [ ./theme.nix ];
}
