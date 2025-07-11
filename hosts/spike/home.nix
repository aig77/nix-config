{
  pkgs,
  config,
  ...
}: {
  imports = [
    # Programs
    #../../modules/home/programs/discord
    ../../modules/home/programs/fetch
    ../../modules/home/programs/ghostty
    ../../modules/home/programs/git
    ../../modules/home/programs/kitty
    ../../modules/home/programs/lazygit
    ../../modules/home/programs/shell
    ../../modules/home/programs/spicetify
    ../../modules/home/programs/thunar
    ../../modules/home/programs/vim
    ../../modules/home/programs/zen

    # System
    #../../modules/home/system/hyprland
    #../../modules/home/system/rofi
    #../../modules/home/system/hyprpanel
    #../../modules/home/system/waybar
    #../../modules/home/system/wlogout
    #../../modules/home/system/dunst
    ../../modules/home/system/gnome-extensions

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
      NIX_CONFIG_PATH = config.var.configPath;
    };

    file = {};

    # https://nixos.wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "25.05";
  };

  # Let home manager install and manage itself
  programs.home-manager.enable = true;
}
