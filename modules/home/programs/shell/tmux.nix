{
  pkgs,
  config,
  ...
}: {
  programs.tmux = {
    enable = true;
    shell = "${pkgs.${config.var.shell}}/bin/${config.var.shell}";
    clock24 = true;
    keyMode = "vi";
    baseIndex = 1;
    mouse = true;
    sensibleOnTop = true;
    prefix = "C-space";

    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      yank
    ];

    extraConfig = ''
      set -g default-command "${pkgs.${config.var.shell}}/bin/${config.var.shell} -l"
      set-option -sa terminal-overrides ",xterm*:Tc"

      # Shift Alt vim keys to switch windows
      bind -n M-H previous-window
      bind -n M-L next-window

      # Yanking
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # Visual indicator for spliting windows
      bind | split-window -h
      bind _ split-window -v
    '';
  };
}
