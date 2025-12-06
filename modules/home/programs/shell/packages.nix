{pkgs, ...}: {
  home.packages = with pkgs; [
    alejandra # Nix code formatter
    bat # Cat with syntax highlighting
    btop # Resource monitor (CPU/RAM/disk)
    curl
    cmake
    deadnix # Remove unused Nix code
    eza # Modern ls replacement
    fzf # Fuzzy finder for files/history
    gcc
    gh # GitHub CLI
    git
    glow # Markdown viewer for terminal
    gnumake
    jq # JSON processor
    manix # Fast Nix documentation search
    nil # Nix language server
    ninja # Fast build system
    nixd # Nix language server
    nix-output-monitor # Pretty Nix build output
    nix-tree # Browse Nix dependency trees
    pkg-config
    ripgrep # Fast recursive search tool
    statix # Nix linter
    tldr # Simplified man pages
    unzip
    xz
    wget
    zip
  ];
}
