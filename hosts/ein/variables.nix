{lib, ...}: {
  options = {
    var = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };

  config.var = let
    username = "arturo";
    hostname = "ein";
    configPath = "/home/${username}/.config/nix-config";
  in {
    inherit username hostname configPath;
    profileImagePath = configPath + "/themes/profilepics/ein.jpg";
    pokemonSprite = "umbreon -s";

    git = {
      username = "aig77";
      email = "";
    };

    terminal = "ghostty";
    browser = "zen";
  };
}
