{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      rs = "sudo nixos-rebuild switch";
      rsf = "sudo nixos-rebuild switch --flake";
      rtf = "sudo nixos-rebuild test --flake";
      cd = "z";
      ls = "eza --icons=always --no-quotes";
      tree = "eza --icons=always --tree --no-quotes";
      cat = "bat --theme=base16 --color=always --wrap=never";
    };

    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      ignoreAllDups = true;
      saveNoDups = true;
      findNoDups = true;
      append = true;
      share = true;
      ignoreSpace = true;
    };

    initExtraFirst =
      "krabby name umbreon -s --no-title | fastfetch --file-raw -";

    initExtra = ''
      # Keybindings
      bindkey -e
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward

      # Completion styling
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      zstyle ':completion:*' keep-prefix true
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

      # fzf-tab
      # disable sort when completing `git checkout`
      zstyle ':completion:*:git-checkout:*' sort false
      # set descriptions format to enable group support
      # NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
      zstyle ':completion:*:descriptions' format '[%d]'
      # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
      zstyle ':completion:*' menu no
      # preview directory's content with eza when completing cd
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
      # custom fzf flags
      # NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
      zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
      # To make fzf-tab follow FZF_DEFAULT_OPTS.
      # NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
      zstyle ':fzf-tab:*' use-fzf-default-opts yes
      # switch group using `<` and `>`
      zstyle ':fzf-tab:*' switch-group '<' '>'
    '';

    plugins = [
      {
        name = "zsh-vi-mode";
        src = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode";
      }
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      } 
    ];
  };

  home.packages = with pkgs; [ 
    bat 
    eza
    ripgrep
    krabby # for pokemon sprites
    zsh-fzf-tab
  ];
}
