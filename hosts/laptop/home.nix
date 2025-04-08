{ inputs, lib, config, pkgs, ... }:

{
  
  imports = [
    ../../modules/home/fetch
    #../../modules/home/fonts
    ../../modules/home/ghostty
    ../../modules/home/git
    #../../modules/home/gtk
    ../../modules/home/hyprland
    ../../modules/home/kitty
    ../../modules/home/rofi
    ../../modules/home/thunar
    ../../modules/home/vim
    ../../modules/home/waybar
    ../../modules/home/wlogout
    ../../modules/home/zen
    ../../modules/home/zsh

    ./variables.nix
  ];
 
  home = {
    username = "arturo";
    homeDirectory = "/home/arturo";

    packages = with pkgs; [
      btop
      mission-center
      krabby
      zip
      unzip
      xz
      vlc
      bitwarden
      #inputs.swww.packages.${pkgs.system}.swww
      pavucontrol
      qpwgraph
      feh
      networkmanagerapplet
    ]; 

    sessionVariables = {
      # EDITOR = "nvim";
      WALLPAPERS = "$HOME/Pictures/Wallpapers";
    };

    file = {};

    # https://nixos.wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";
  };

  # Let home manager install and manage itself
  programs.home-manager.enable = true;
}
