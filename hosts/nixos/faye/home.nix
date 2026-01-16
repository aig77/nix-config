{
  inputs,
  config,
  pkgs,
  ...
}: let
  modulesPath = ../../../modules;
in {
  imports = [
    ./variables.nix

    # Programs
    (modulesPath + /home/programs/alacritty)
    # (modulesPath + /home/programs/cava)
    (modulesPath + /home/programs/fetch)
    (modulesPath + /home/programs/ghostty)
    (modulesPath + /home/programs/git)
    (modulesPath + /home/programs/lazygit)
    (modulesPath + /home/programs/neovim)
    (modulesPath + /home/programs/nixcord)
    (modulesPath + /home/programs/obs)
    (modulesPath + /home/programs/shell)
    (modulesPath + /home/programs/spotify)
    (modulesPath + /home/programs/thunar)
    (modulesPath + /home/programs/vim)
    (modulesPath + /home/programs/zathura)
    (modulesPath + /home/programs/zen)

    # System
    # (modulesPath + /home/system/gnome-extensions)
    (modulesPath + /home/system/hyprland)
    # (modulesPath + /home/system/niri)

    # Scripts
    (modulesPath + /home/scripts/screenshot)
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    packages = with pkgs; [
      # Desktop
      amdgpu_top # amd gpu monitoring
      bitwarden-desktop # password manager
      brave # backup browser
      inputs.claude-desktop.packages.${pkgs.stdenv.hostPlatform.system}.claude-desktop-with-fhs # claude
      gnome-calculator
      httpie-desktop # api testing client
      lmstudio # local llms
      mission-center # system monitor
      networkmanagerapplet # gui network manager
      obsidian # note taking tool
      pavucontrol # volume control
      qpwgraph # pipewire graph manager
      vlc # video player

      # CLI
      claude-code # claude tui
      feh # image viewer
      opencode # oss llm tui

      # Programming
      rustc
      cargo
      rust-analyzer
      clippy
      rustfmt

      python3
      uv

      go
      gopls
      golangci-lint
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
