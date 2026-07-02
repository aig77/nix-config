_: {
  flake.modules.homeManager.noctalia = {
    inputs,
    config,
    osConfig,
    ...
  }: {
    imports = [inputs.noctalia.homeModules.default];

    programs.noctalia.enable = true;

    # Left unmanaged on purpose: noctalia is configured by hand / through its own
    # Settings GUI first. Symlinking to a repo-tracked file means edits (from either
    # source) land directly in git, with no rebuild required to pick them up.
    xdg.configFile."noctalia/config.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${osConfig.var.repoPath}/modules/features/noctalia/config.toml";
  };
}
