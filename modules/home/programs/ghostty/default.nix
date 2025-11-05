# darwin package has issue: https://github.com/NixOS/nixpkgs/issues/388984
# install using brew on darwin
{pkgs, ...}: let
  inherit (pkgs.stdenv) isDarwin;
  ghosttyPkg =
    if isDarwin
    then null
    else pkgs.ghostty;
  hasPkg = ghosttyPkg != null;
in {
  programs.ghostty = {
    enable = true;
    package = ghosttyPkg;

    # Only enable these when a package exists (i.e., non-Darwin here)
    installBatSyntax = hasPkg;
    installVimSyntax = hasPkg;

    settings = {
      window-padding-x = 10;
      window-padding-balance = true;
      shell-integration-features = "ssh-env,ssh-terminfo";
    };
  };
}
