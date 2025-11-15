{
  inputs,
  config,
  pkgs,
  ...
}: let
  modulesPath = ../../../modules;
in {
  imports = [
    # Programs
    (modulesPath + /home/programs/email)
    (modulesPath + /home/programs/fetch)
    (modulesPath + /home/programs/ghostty)
    (modulesPath + /home/programs/git)
    (modulesPath + /home/programs/lazygit)
    (modulesPath + /home/programs/neovim)
    (modulesPath + /home/programs/nixcord)
    (modulesPath + /home/programs/obs)
    (modulesPath + /home/programs/obsidian)
    (modulesPath + /home/programs/shell)
    (modulesPath + /home/programs/spotify)
    (modulesPath + /home/programs/thunar)
    (modulesPath + /home/programs/vim)
    (modulesPath + /home/programs/zen)

    # System
    (modulesPath + /home/system/hyprland)
    # (modulesPath + /home/system/gnome-extensions)

    # Scripts
    (modulesPath + /home/scripts/screenshot)

    ./variables.nix
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    packages = with pkgs; [
      bitwarden-desktop
      brave
      cava
      inputs.claude-desktop.packages.${pkgs.stdenv.hostPlatform.system}.claude-desktop-with-fhs # claude
      feh # cli image viewer
      httpie
      kitty
      lmstudio
      mission-center
      networkmanagerapplet
      # obs-studio
      opencode
      pavucontrol # volume control
      qpwgraph # pipewire graph manager
      vlc # video player
    ];

    sessionVariables = {
      EDITOR = "nvim";
      WALLPAPERS = "$HOME/Pictures/Wallpapers";
      XDG_CONFIG_HOME = "$HOME/.config";
    };

    file = {};

    # https://nixos.wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "25.05";
  };

  # Let home manager install and manage itself
  programs.home-manager.enable = true;
}
