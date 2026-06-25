{config, ...}: let
  hm = config.flake.modules.homeManager;
in {
  configurations.darwin.ein.module = {
    config,
    pkgs,
    ...
  }: {
    home-manager.users.${config.var.username} = {
      imports = with hm; [ghostty zen];
      home = {
        homeDirectory = "/Users/${config.var.username}";
        stateVersion = "24.11";
        packages = with pkgs; [opencode];
        sessionVariables = {
          EDITOR = "nvim";
          XDG_CONFIG_HOME = "$HOME/.config";
        };
      };
    };
  };
}
