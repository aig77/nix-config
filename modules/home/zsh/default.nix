{
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      rs = "sudo nixos-rebuild switch";
      rsf = "sudo nixos-rebuild switch --flake ~/.config/nix";
    };

    history = {
      size = 10000;
      #path = "${config.xdg.dataHome}/zsh/history";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "simple";
    };
  };
     
}
