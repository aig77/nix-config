{ pkgs, ... }: {
  
  imports = [
    ../../modules/home/discord
    ../../modules/home/dunst
    ../../modules/home/fetch
    ../../modules/home/ghostty
    ../../modules/home/git
    ../../modules/home/hyprland
    ../../modules/home/kitty
    ../../modules/home/lazygit
    ../../modules/home/rofi
    ../../modules/home/spicetify
    ../../modules/home/thunar
    ../../modules/home/vim
    ../../modules/home/waybar
    ../../modules/home/wlogout
    ../../modules/home/zen
    ../../modules/home/zsh

    ../../modules/home/scripts/screenshot

    ./variables.nix
  ];
 
  home = {
    username = "arturo";
    homeDirectory = "/home/arturo";

    packages = with pkgs; [
      bitwarden
      zip
      unzip
      xz
      btop
      krabby
      mission-center
      feh
      vlc
      networkmanagerapplet
      pavucontrol
      qpwgraph
      discord-canary
      nixd

      # backups
      brave
      vscodium
      zed-editor
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
