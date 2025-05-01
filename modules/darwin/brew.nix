{config, ...}: {
  #nix-homebrew = {
  #  enable = true;
  #  user = config.var.username;
  #  mutableTaps = false;
  #};

  homebrew = {
    enable = true;
    onActivation.upgrade = true;

    extraConfig = ''
      cask_args appdir: "~/Applications"
    '';

    casks = [
      "raycast"
      "ghostty" # temporary while home manager doesnt work
      "zen-browser"
    ];

    masApps = {
      #  XCode = 497799835;
    };
  };
}
