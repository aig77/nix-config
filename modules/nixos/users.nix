{ pkgs, ... }: {
  programs.zsh.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    arturo = {
      isNormalUser = true;
      description = "Arturo";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
      packages = with pkgs; [];
    };
  };
}
