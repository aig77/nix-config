_: {
  flake.modules.homeManager.spotify = {inputs, ...}: {
    imports = [inputs.spicetify-nix.homeManagerModules.default];

    programs.spicetify = {enable = true;};
  };
}
