{pkgs}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    age
    git
    neovim
    nixd
    sops
  ];

  EDITOR = "nvim";
}
