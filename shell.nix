{
  pkgs,
  config,
  ...
}:
pkgs.mkShell {
  NIX_CONFIG = "extra-experimental-features = nix-command flakes ca-derivations";
  packages = with pkgs; [
    nix
    home-manager
    git
    sops
    ssh-to-age
    gnupg
    age
  ];

  shellHook = ''
    echo "󱄅 Entered Nix dev shell!"
    ${config.pre-commit.installationScript}
  '';

  env = {
    EDITOR = "vim";
    NIXPKGS_ALLOW_UNFREE = "1";
  };
}
