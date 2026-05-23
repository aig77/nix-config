{
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        age
        git
        neovim
        nixd
        sops
        lua
        stylua
        qt6.qtdeclarative
      ];
      EDITOR = "nvim";
    };
  };
}
