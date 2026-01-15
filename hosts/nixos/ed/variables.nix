{lib, ...}: {
  options.var = lib.mkOption {
    type = lib.types.submodule {
      options = {
        username = lib.mkOption {type = lib.types.str;};
        hostname = lib.mkOption {type = lib.types.str;};
        shell = lib.mkOption {type = lib.types.enum ["zsh" "fish"];};
      };
    };
    default = {};
  };

  config.var = {
    username = "arturo";
    hostname = "ed";
    shell = "zsh"; # zsh or fish
  };
}
