{config, ...}: {
  imports = [
    ../../modules/nixos/darwin.nix
    ../../modules/nixos/home-manager.nix
    ../../modules/nixos/nix.nix
    ./variables.nix
    ./theme.nix
  ];

  homebrew = {
    # not available in nixpkgs for darwin
    casks = [
      "docker"
      "discord"
      "ghostty"
      "lm-studio"
      "raycast"
      "zen-browser"
    ];

    masApps = {
      #  XCode = 497799835;
    };
  };

  # due to xterm ghostty issue
  programs.fish.initExtra = ''
    if [[ "$TERM" == "xterm-ghostty" ]]; then
      export TERM=xterm-256color
    fi
  '';

  system.primaryUser = config.var.username;
  home-manager.users.arturo = import ./home.nix;
}
