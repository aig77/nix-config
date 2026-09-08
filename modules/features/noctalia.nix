_: {
  flake.modules.homeManager.noctalia = {inputs, ...}: {
    imports = [inputs.noctalia.homeModules.default];
    programs.noctalia.enable = true;
  };
}
