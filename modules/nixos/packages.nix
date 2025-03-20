{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    gcc
    wget
    curl
  ];
  
  # Enable hyprland system wide
  #programs.hyprland.enable = true;
}
