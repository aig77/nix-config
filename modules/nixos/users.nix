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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    ${username} = {
      isNormalUser = true;
      initialPassword = "";
      extraGroups = ["wheel" "networkmanager" "seat" "audio" "video" "input"];
      shell = pkgs.${shell}; # fish or zsh
    };
  };
}
