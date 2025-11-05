{
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    # Programs
    ../../modules/home/programs/email
    ../../modules/home/programs/fetch
    ../../modules/home/programs/ghostty
    ../../modules/home/programs/git
    ../../modules/home/programs/lazygit
    ../../modules/home/programs/neovim
    ../../modules/home/programs/nixcord
    ../../modules/home/programs/shell
    ../../modules/home/programs/spotify
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
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    packages = with pkgs; [
      bitwarden-desktop
      brave
      btop
      inputs.claude-desktop.packages.${pkgs.system}.claude-desktop-with-fhs # claude
      feh # cli image viewer
      jq
      lmstudio
      manix # nix cli docs
      mission-center
      networkmanagerapplet
      nil # nix language server
      obs-studio
      inputs.nix-ai-tools.packages.${pkgs.system}.opencode
      pavucontrol # volume control
      qpwgraph # pipewire graph manager
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
