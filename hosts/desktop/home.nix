{ pkgs, ... }: {
  imports = [
    # Programs
    ../../modules/home/programs/discord
    ../../modules/home/programs/fetch
    ../../modules/home/programs/ghostty
    ../../modules/home/programs/git
    ../../modules/home/programs/kitty
    ../../modules/home/programs/lazygit
    ../../modules/home/programs/spicetify
    ../../modules/home/programs/thunar
    ../../modules/home/programs/vim
    ../../modules/home/programs/zen

    # System
    ../../modules/home/system/dunst
    ../../modules/home/system/hyprland
    ../../modules/home/system/rofi
    ../../modules/home/system/waybar
    ../../modules/home/system/wlogout
    ../../modules/home/system/zsh

    # Scripts
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

    file = { };

    # https://nixos.wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.11";
  };

  # Let home manager install and manage itself
  programs.home-manager.enable = true;
}
