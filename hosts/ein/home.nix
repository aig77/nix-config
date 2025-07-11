{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    # Programs
    ../../modules/home/programs/fetch
    ../../modules/home/programs/ghostty/darwin.nix # installed using homebrew
    ../../modules/home/programs/git
    ../../modules/home/programs/kitty
    ../../modules/home/programs/lazygit
    ../../modules/home/programs/shell
    ../../modules/home/programs/vim

    ./variables.nix
  ];

  home = {
    username = config.var.username;
    homeDirectory = "/Users/" + config.var.username;

    packages = with pkgs; [
      zip
      unzip
      xz
      btop
      discord-canary
      spotify
      nixd

      # doesnt work on aarch yet, installed with homebrew
      #inputs.zen-browser.packages.${system}.default

      # backups
      brave
      #vscodium
      zed-editor
    ];

    sessionVariables = {
      # EDITOR = "nvim";
      WALLPAPERS = "$HOME/Pictures/Wallpapers";
      NIX_CONFIG_PATH = config.var.configPath;
    };

    file = {};

    # https://nixos.wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.11";
  };

  # Let home manager install and manage itself
  programs.home-manager.enable = true;
}
