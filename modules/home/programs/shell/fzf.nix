{
  config,
  lib,
  ...
}: let
  colors = config.lib.stylix.colors.withHashtag;
  accent = colors.base0D;
  foreground = colors.base05;
  muted = colors.base03;
in {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    colors = lib.mkForce {
      "fg+" = accent;
      "bg+" = "-1";
      "fg" = foreground;
      "bg" = "-1";
      "prompt" = muted;
      "pointer" = accent;
      "scrollbar" = muted;
      "separator" = muted;
    };
    defaultOptions = [
      "-i"
      "--margin=1"
      "--layout=reverse"
      "--border=none"
      "--info='hidden'"
    ];
  };
}
