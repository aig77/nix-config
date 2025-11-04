{
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    # Programs
    ../../modules/home/programs/fetch
    ../../modules/home/programs/ghostty
    ../../modules/home/programs/git
    ../../modules/home/programs/lazygit
    ../../modules/home/programs/neovim
    ../../modules/home/programs/nixcord
    ../../modules/home/programs/shell
    ../../modules/home/programs/spotify
    ../../modules/home/programs/thunar
    ../../modules/home/programs/thunderbird
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
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    packages = with pkgs; [
      bitwarden-desktop
      brave
      btop
      inputs.nix-ai-tools.packages.${pkgs.system}.claude-desktop
      feh
      lmstudio
      manix
      mission-center
      networkmanagerapplet
      nil
      nixd
      obs-studio
      inputs.nix-ai-tools.packages.${pkgs.system}.opencode
      pavucontrol
      qpwgraph
      ripgrep
      unzip
      vlc
      xz
      zip
    ];

    sessionVariables = {
      EDITOR = "nvim";
      WALLPAPERS = "$HOME/Pictures/Wallpapers";
    };

    file = {};

    # https://nixos.wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "25.05";
  };

  # Let home manager install and manage itself
  programs.home-manager.enable = true;
}
