{lib, ...}: {
  options.var = lib.mkOption {
    type = lib.types.attrs;
    default = {};
  };

  config.var = {
    username = "arturo";
    hostname = "spike";
    pokemonSprite = "umbreon -s";

    git = {
      username = "aig77";
      email = "";
    };

    terminal = "ghostty";
    browser = "zen";
  };
}
