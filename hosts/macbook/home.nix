{ pkgs, inputs, ... }: {
  imports = [
    # Programs
    ../../modules/home/programs/fetch
    #../../modules/home/programs/ghostty # doesnt work
    ../../modules/home/programs/git
    ../../modules/home/programs/kitty
    ../../modules/home/programs/lazygit
    ../../modules/home/programs/shell
    ../../modules/home/programs/vim

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
      
      # doesnt work on aarch yet
      #inputs.zen-browser.packages.${system}.default 

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

  programs.ghostty = { 
    enable = true;
    package = null;
    enableZshIntegration = true;
    settings = {
      window-padding-x = 10;
      window-padding-balance = true; 
    };
  };

}
