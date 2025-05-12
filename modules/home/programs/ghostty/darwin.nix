# darwin package has issue: https://github.com/NixOS/nixpkgs/issues/388984
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
