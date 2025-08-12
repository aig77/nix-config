{pkgs, ...}: {
  # Enable shell
  environment.shells = with pkgs; [fish zsh];
  programs.fish.enable = true;
  #programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    arturo = {
      isNormalUser = true;
      description = "Arturo";
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.fish; # fish or zsh
      packages = with pkgs; [];
    };
  };
}
