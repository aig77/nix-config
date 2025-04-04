{ pkgs, config, ... }:

{
  imports = [
    ../../themes
  ];

  #config.stylix = {
  #  enable = true;
  #  base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark.yaml";
  #};

  #gitUsername = "";
  #gitEmail = "";

  #clock24h = true;

  #browser = "zen";
  #terminal = "kitty";
  #keyboardLayout = "us";
  #consoleKeyMap = "us";
}
