_: {
  configurations.nixos.spike.module = {
    var = {
      username = "arturo";
      hostname = "spike";
      location = "Miami";
      shell = "zsh";
      terminal = "ghostty";
      browser = "zen";
      fileManager = "thunar";
      lock = "hyprlock";
      wallpaperEngine = "awww";
    };
  };
}
