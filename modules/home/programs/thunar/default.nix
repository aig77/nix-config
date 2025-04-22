{ pkgs, ... }: {
  home.packages = with pkgs; [ xfce.thunar ];

  gtk = {
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };
}
