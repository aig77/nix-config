_: {
  configurations.nixos.spike.module = {
    config,
    pkgs,
    inputs,
    ...
  }: {
    home-manager.users.${config.var.username} = {
      home = {
        homeDirectory = "/home/${config.var.username}";
        stateVersion = "25.05";
        packages = with pkgs; [
          amdgpu_top
          bitwarden-desktop
          inputs.claude-desktop.packages.${pkgs.system}.claude-desktop-fhs
          gnome-calculator
          imv
          lmstudio
          mission-center
          networkmanagerapplet
          obsidian
          pavucontrol
          qpwgraph
          vlc
          yazi
        ];
        sessionVariables = {
          EDITOR = "nvim";
          WALLPAPERS = "$HOME/Pictures/Wallpapers";
          XDG_CONFIG_HOME = "$HOME/.config";
        };
      };
    };
  };
}
