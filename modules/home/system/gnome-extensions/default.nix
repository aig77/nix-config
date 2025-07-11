{pkgs, ...}: {
  home.packages = with pkgs; [
    gnome-tweaks
    gnomeExtensions.blur-my-shell
    gnomeExtensions.alphabetical-app-grid
  ];

  dconf.settings = {
    # Extensions
    "org/gnome/shell" = {
      disable-user-extensions = false;
      disabled-extensions = ["disabled"];
      enabled-extensions = [
        "blur-my-shell@aunetx"
        "alphabetical-app-grid@honnip"
      ];
    };
  };
}
