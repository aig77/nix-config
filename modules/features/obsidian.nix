_: {
  flake.modules.homeManager.obsidian = _: {
    programs.obsidian.enable = true;
    stylix.targets.obsidian.enable = false;
  };
}
