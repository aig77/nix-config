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
    shellHook = ''
      echo "󱄅 Entered default Nix shell!"
    '';
  };

  rust = pkgs.mkShell {
    name = "rust-shell";
    packages = with pkgs; [
      rust-bin.stable.latest.default
      rust-analyzer
      cargo
    ];
    RUST_BACKTRACE = 1;
    shellHook = ''
      echo "Entered Rust shell! 🦀"
    '';
  };

  rust-nightly = let
    nightly-bin = pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
  in
    pkgs.mkShell {
      name = "rust-nightly-shell";
      packages = with pkgs; [
        nightly-bin
        rust-analyzer
        cargo
      ];
      RUST_BACKTRACE = 1;
      shellHook = ''
        echo "Entered Rust shell! 🦀 🌙"
      '';
    };
}
