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
      ];
      EDITOR = "nvim";
    };
  };
}
