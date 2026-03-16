{
  inputs,
  config,
  lib,
  ...
}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs =
      {
        inherit inputs;
      }
      // lib.optionalAttrs (config ? sops) {
        inherit (config) sops;
      };
  };
}
