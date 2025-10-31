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
      "claude"
      "discord"
      "docker"
      "ghostty"
      "raycast"
      "lm-studio"
      "steam"
      "whatsapp"

      # experiencing issues
      # https://github.com/0xc000022070/zen-browser-flake/issues/128
      # https://nixpk.gs/pr-tracker.html?pr=449689
      "zen-browser"
    ];

    masApps = {
      #  XCode = 497799835;
    };
  };

  system.primaryUser = config.var.username;
  home-manager.users.arturo = import ./home.nix;
}
