{
  config,
  lib,
  ...
}: {
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
      email = config.sops.secrets.github-email.path;
    };

    shell = "zsh";
    terminal = "ghostty";
    browser = "zen";
  };
}
