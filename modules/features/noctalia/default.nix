_: {
  flake.modules.homeManager.noctalia = {
    inputs,
    config,
    lib,
    osConfig,
    ...
  }: {
    imports = [inputs.noctalia.homeModules.default];

    programs.noctalia.enable = true;

    # Left unmanaged on purpose: noctalia is configured by hand / through its own
    # Settings GUI first. Symlinking to a repo-tracked file means edits (from either
    # source) land directly in git, with no rebuild required to pick them up.
    # mkForce: upstream homeModules.default also writes this file from
    # programs.noctalia.settings; our symlink must win.
    xdg.configFile."noctalia/config.toml".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${osConfig.var.repoPath}/modules/features/noctalia/config.toml"
    );
  };
}
