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
    #../../modules/home/programs/nixcord
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
      brave
      btop
      inputs.nix-ai-tools.packages.${pkgs.system}.opencode
      nil
      xz
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
