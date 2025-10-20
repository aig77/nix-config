# darwin package has issue: https://github.com/NixOS/nixpkgs/issues/388984
# install using brew on darwin
{
  pkgs,
  inputs,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin;
  ghosttyPkg =
    if isDarwin
    then null
    else inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;
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
    };
  };
}
