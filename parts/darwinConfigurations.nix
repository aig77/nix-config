# Declares configurations.darwin as an intermediate option so that each host file in
# darwinConfigurations/ can add its own entry without conflicting with the others.
# The collected set is then exposed as flake.darwinConfigurations.
{
  lib,
  config,
  ...
}: {
  options.configurations.darwin = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.unspecified;
    default = {};
  };

  config.flake.darwinConfigurations = config.configurations.darwin;
}
