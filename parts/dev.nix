{inputs, ...}: {
  imports = [inputs.git-hooks-nix.flakeModule];
  perSystem = {pkgs, ...}: {
    devShells.default = import ../shell.nix {inherit pkgs;};
    formatter = pkgs.alejandra;
    pre-commit = import ../lib/pre-commit.nix;
  };
}
