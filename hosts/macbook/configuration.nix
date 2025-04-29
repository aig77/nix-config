{ pkgs, config, ... }: {
  imports = [
    ../../modules/nixos/darwin.nix
    ../../modules/nixos/home-manager.nix
    ../../modules/nixos/users.nix

    ./variables.nix
  ];

  # Make applications accessible through Spotlight
  environment.systemPackages = with pkgs; [
    mkalias
  ];

  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    };
  in
    pkgs.lib.mkForce ''
      # Set up applications.
      echo "setting up /Applications..." >&2
      rm -rf ~/Applications/Home\ Manager 
      mkdir -p ~/Applications/Home\ Manager 
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';

  home-manager.users.arturo = import ./home.nix;
  
  # Set Git commit hash for darwin-version.
  #system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
  
  # The platform the configuration will be used on
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Disabled for Determinate systems nix
  nix.enable = false;
}
