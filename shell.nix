{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
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

  RUST_BACKTRACE = 1;
}
