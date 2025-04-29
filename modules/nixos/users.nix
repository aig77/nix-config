{ pkgs, config, ... }: {
  programs.zsh.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    arturo = if config.var.hostname != "macbook" then {
      isNormalUser = true;
      description = "Arturo";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
      packages = with pkgs; [ ];
    } else {
      home = "/Users/arturo";
      shell = pkgs.zsh;
    };
  };
}
