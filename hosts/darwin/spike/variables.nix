{lib, ...}: {
  options.var = lib.mkOption {
    type = lib.types.attrs;
    default = {};
  };

  config.var = {
    username = "arturo";
    hostname = "spike";

    shell = "zsh";
    terminal = "ghostty";
    browser = "zen";
  };
}
