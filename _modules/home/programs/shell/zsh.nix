{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.lib.stylix) colors;
in {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    syntaxHighlighting.styles = {
      # Variables
      variable = "fg=#${colors.base0C}";
      assign = "fg=#${colors.base0C}";

      # Commands
      command = "fg=#${colors.base0D}";
      builtin = "fg=#${colors.base0D}";
      function = "fg=#${colors.base0D}";
      alias = "fg=#${colors.base0D}";

      # Strings
      single-quoted-argument = "fg=#${colors.base0B}";
      double-quoted-argument = "fg=#${colors.base0B}";

      # Paths
      path = "fg=#${colors.base0A},underline";

      # Options/flags
      single-hyphen-option = "fg=#${colors.base09}";
      double-hyphen-option = "fg=#${colors.base09}";

      # Errors
      unknown-token = "fg=#${colors.base08}";
      command-not-found = "fg=#${colors.base08}";
    };

    shellAliases = {
      ll = "ls -l";
      ls = "eza --icons=always --no-quotes";
      tree = "eza --icons=always --tree --no-quotes";
      cat = "bat --theme=base16 --color=always --wrap=never";
      fetch = "${pkgs.krabby}/bin/krabby name umbreon -s --no-title | ${pkgs.fastfetch}/bin/fastfetch --file-raw -";
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

    initContent = lib.mkBefore ''
      ${pkgs.krabby}/bin/krabby name umbreon -s --no-title | ${pkgs.fastfetch}/bin/fastfetch --file-raw -

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
      zstyle ':fzf-tab:*' fzf-flags --bind=tab:accept
      # To make fzf-tab follow FZF_DEFAULT_OPTS.
      # NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
      zstyle ':fzf-tab:*' use-fzf-default-opts yes
      # switch group using `<` and `>`
      zstyle ':fzf-tab:*' switch-group '<' '>'

      # Autosuggestion styling - darker gray for better visibility
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#${colors.base03},bold"

      # direnv setup
      #eval "$(direnv hook zsh)"
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

  # Enable zsh integrations
  programs = {
    direnv.enableZshIntegration = true;
    fzf.enableZshIntegration = true;
    ghostty.enableZshIntegration = true;
    starship.enableZshIntegration = true;
    zoxide.enableZshIntegration = true;
  };

  home.packages = with pkgs; [zsh-fzf-tab];
}
