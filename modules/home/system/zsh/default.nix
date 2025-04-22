{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      rs = "sudo nixos-rebuild switch";
      rsf = "sudo nixos-rebuild switch --flake --show-trace";
      rtf = "sudo nixos-rebuild test --flake --show-trace";
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

    initExtraFirst =
      "krabby name umbreon -s --no-title"; # | fastfetch --file-raw -";

    initExtra = "source ~/.p10k.zsh";

    plugins = [{
      name = "powerlevel10k";
      src = pkgs.zsh-powerlevel10k;
      file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    }];
  };

  home.packages = [ pkgs.meslo-lgs-nf ]; # for p10k
}
