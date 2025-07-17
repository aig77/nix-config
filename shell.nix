{pkgs, ...}:
pkgs.mkShell {
  NIX_CONFIG = "extra-experimental-features = nix-command flakes ca-derivations";
  packages = with pkgs; [
    nix
    home-manager
    git
    pre-commit
    sops
    ssh-to-age
    gnupg
    age
  ];

  shellHook = ''
    echo "󱄅 Entered Nix dev shell!"
    if [ ! -f .git/hooks/pre-commit ]; then
      echo  "🧪 Installing pre-commit hooks..."
      pre-commit install
      echo "✅ pre-commit hooks installed."
    fi
  '';

  env = {
    EDITOR = "vim";
    NIXPKGS_ALLOW_UNFREE = "1";
  };
}
