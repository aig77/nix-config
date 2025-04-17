{ pkgs, ... }: {
  fonts.fontconfig.enable = true;

  home.packages = [
    # <= 24.11
    #(pkgs.nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })

    # > 24.11
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.jetbrains-mono
  ];
}
