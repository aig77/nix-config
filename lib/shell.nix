{pkgs, ...}:
pkgs.mkShell {
  packages = with pkgs; [
    neovim
    nixd
  ];

  EDITOR = "nvim";
}
