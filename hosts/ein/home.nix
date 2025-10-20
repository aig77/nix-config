{
  pkgs,
  config,
  ...
}: {
  imports = [
    # Programs
    ../../modules/home/programs/discord
    ../../modules/home/programs/fetch
    ../../modules/home/programs/ghostty
    ../../modules/home/programs/git
    ../../modules/home/programs/lazygit
    ../../modules/home/programs/neovim
    ../../modules/home/programs/opencode
    ../../modules/home/programs/shell
    ../../modules/home/programs/spotify
    ../../modules/home/programs/vim
    #../../modules/home/programs/zen

    ./variables.nix
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/Users/" + config.var.username;

    packages = with pkgs; [
      zip
      unzip
      xz
      btop
      nil
      nixd

      # backups
      brave
      #vscodium
      #zed-editor
    ];

    sessionVariables = {
      EDITOR = "nvim";
      XDG_CONFIG_HOME = "$HOME/.config";
      WALLPAPERS = "$HOME/Pictures/Wallpapers";
    };

    file = {};

    # https://nixos.wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.11";
  };

  # Let home manager install and manage itself
  programs.home-manager.enable = true;
}
