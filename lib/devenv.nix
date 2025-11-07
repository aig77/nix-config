{pkgs, ...}: {
  shells.default = {
    packages = with pkgs; [
      neovim
      nixd
      alejandra
      statix
      deadnix
    ];

    enterShell = ''
      echo "󱄅 Entered Nix dev shell!"
    '';

    env = {
      NIX_CONFIG = "extra-experimental-features = nix-command flakes ca-derivations";
      EDITOR = "nvim";
    };

    git-hooks.hooks = {
      alejandra.enable = true;
      deadnix.enable = true;
      statix.enable = true;
    };

    containers = pkgs.lib.mkForce {};
  };
}
