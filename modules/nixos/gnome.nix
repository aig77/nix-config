{pkgs, ...}: {
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  environment.gnome.excludePackages = with pkgs; [
    atomix # puzzle game
    cheese # webcam tool
    epiphany # web browser
    evince # document viewer
    geary # email reader
    gedit # text editor
    gnome-characters
    gnome-music
    gnome-photos
    gnome-terminal
    gnome-tour
    gnome-contacts
    gnome-weather
    gnome-clocks
    gnome-maps
    gnome-console
    gnome-text-editor
    gnome-calendar
    gnome-system-monitor
    gnome-logs
    gnome-font-viewer
    gnome-sound-recorder
    gnome-disk-utility
    gnome-connections
    hitori # sudoku game
    iagno # go game
    tali # poker game
    totem # video player
    file-roller # archive manager
    simple-scan # document scanner
    seahorse # passwords and keys
    decibels # audio player
    loupe # image viewer
    baobab # disk usage analyzer
    snapshot # camera
  ];
}
