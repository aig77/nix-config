# Declares configurations.nixos as an intermediate option so that each host file in
# nixosConfigurations/ can add its own entry without conflicting with the others.
# The collected set is then exposed as flake.nixosConfigurations.
{
  lib,
  config,
  ...
}: {
  options.configurations.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.unspecified;
    default = {};
  };

  config.flake.nixosConfigurations = config.configurations.nixos;
}
