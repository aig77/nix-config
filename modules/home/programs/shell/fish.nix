{
  pkgs,
  config,
  ...
}: let
  colors = config.lib.stylix.colors.withHashtag;
in {
  programs.fish = {
    enable = true;

    # Abbreviations = nicer aliases (expand as you type)
    shellAbbrs = {
      ll = "ls -l";
    };

    # Command aliases (override commands)
    shellAliases = {
      cd = "z"; # via zoxide
      ls = "eza --icons=always --no-quotes";
      tree = "eza --icons=always --tree --no-quotes";
      cat = "bat --theme=base16 --color=always --wrap=never";
    };

    interactiveShellInit = ''
      # Greeting: krabby piped into fastfetch
      set -g fish_greeting ""
      function fish_greeting
        fetch
      end

      # Vi mode
      fish_vi_key_bindings

      # Up and down arrow chronological navigation
      bind -M insert \e\[A history-search-backward
      bind -M insert \e\[B history-search-forward
      bind \e\[A history-search-backward
      bind \e\[B history-search-forward

      # Also set ctl-p and ctl-n as backup
      bind -M insert \cp history-search-backward
      bind -M insert \cn history-search-forward
      bind \cp history-search-backward
      bind \cn history-search-forward

      # fzf integration (directories, git, history, variables, processes, etc.)
      # Provided by fzf.fish plugin
      if type -q fzf_configure_bindings
        fzf_configure_bindings --directory=\ct --git_log=\cl --git_status=\cg --history=\cr
      end

      # Save all commands (even failed ones) in history
      set -U fish_history_save all
    '';

    shellInitLast = ''
      set -g fish_color_param ${colors.base05}     # Bright readable text for params
    '';

    # Plugins
    plugins = with pkgs.fishPlugins; [
      {inherit (fzf-fish) name src;} # Smart FZF completions/pickers
      {inherit (autopair) name src;} # Auto-pair brackets/quotes in fish
      {inherit (done) name src;} # Optional: desktop notif when long cmd finishes
      {inherit (sponge) name src;} # Optional: cleans up ctrl-c artifacts in prompt
    ];
  };

  # Enable fish intergrations
  programs = {
    fzf.enableFishIntegration = true;
    ghostty.enableFishIntegration = true;
    starship.enableFishIntegration = true;
    zoxide.enableFishIntegration = true;
  };
}
