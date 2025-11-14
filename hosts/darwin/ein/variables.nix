{lib, ...}: {
  options.var = lib.mkOption {
    type = lib.types.attrs;
    default = {};
  };

  config.var = {
    username = "arturo";
    hostname = "ein";
    pokemonSprite = "umbreon -s";

    shell = "zsh";
    terminal = "ghostty";
    browser = "zen";
  };
}
