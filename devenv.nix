{pkgs, ...}: {
  shells.default = {
    #languages.nix.enable = true;

    packages = with pkgs; [
      neovim
      nil
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
  };
}
