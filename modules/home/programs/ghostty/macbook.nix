# temporary while theres a ghostty bug in new version?
{
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
