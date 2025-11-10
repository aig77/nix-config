{pkgs}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    git
    neovim
    nixd
  ];

  EDITOR = "nvim";
}
