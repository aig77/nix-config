{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    extraConfig = ''
      cask_args appdir: "~/Applications"
    '';
  };
}
