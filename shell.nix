{pkgs ? import <nixpkgs> {}, ...}: {
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes ca-derivations";
    nativeBuildInputs = with pkgs; [
      nix
      home-manager
      git

      sops
      ssh-to-age
      gnupg
      age
    ];
  };

  code = pkgs.mkShell {
    packages = with pkgs; [
      # Python
      (python3.withPackages (p: with p; [ numpy requests pandas ]))

      # Rust
      rustc
      cargo
      rust-analyzer
      clippy

      # Other
      go
      zig
    ];

    shellHook = ''
      exec $SHELL
    '';

    RUST_BACKTRACE = 1;
  };
}
