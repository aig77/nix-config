{ pkgs, inputs, ... }: {
  imports = [
    # Programs
    ../../modules/home/programs/fetch
    #../../modules/home/programs/ghostty doesnt work
    ../../modules/home/programs/git
    ../../modules/home/programs/kitty
    ../../modules/home/programs/lazygit
    ../../modules/home/programs/shell
    ../../modules/home/programs/vim
    #../../modules/home/programs/zen arm not supported yet

    ./variables.nix
  ];

  home = {
    username = "arturo";
    homeDirectory = "/Users/arturo";

    packages = with pkgs; [
      zip
      unzip
      xz
      btop
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
