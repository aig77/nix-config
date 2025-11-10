{lib, ...}: {
  options.var = lib.mkOption {
    type = lib.types.attrs;
    default = {};
  };

  config.var = {
    username = "arturo";
    hostname = "ein";
    pokemonSprite = "umbreon -s";

    git = {
      username = "aig77";
      email = "";
    };

    shell = "zsh";
    terminal = "ghostty";
    browser = "zen";
  };
}
