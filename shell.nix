{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    (python3.withPackages(p: with p; [
      numpy
      requests
      pandas
    ]))
    rustc
    go
    zig
  ];

  RUST_BACKTRACE = 1;
}