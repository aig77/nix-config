{
  pkgs,
  config,
  ...
}: let
  inherit (config.var) shell username;
in {
  # Enable shell
  environment.shells = with pkgs; [fish zsh];
  programs.${shell}.enable = true;

  users.users = {
    ${username} = {
      isNormalUser = true;
      initialPassword = "password"; # change with passwd
      extraGroups = ["wheel" "networkmanager"];
      shell = pkgs.${shell}; # fish or zsh
    };
  };
}
