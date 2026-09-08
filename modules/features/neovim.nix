_: {
  flake.modules.homeManager.neovim = {pkgs, ...}: {
    stylix.targets.neovim.enable = false;

    home = {
      packages = with pkgs; [
        neovim
        tree-sitter
        lua-language-server
        nixd
        rust-analyzer
        pyright
        gopls
        qt6.qtdeclarative # qmlls
      ];
      shellAliases.vi = "nvim";
    };
  };
}
