{
  programs.obsidian = {
    enable = true;

    vaults = {
      obsidian = {
        target = "Documents/obsidian";

        settings = {
          app.vimMode = true;
        };
      };
    };
  };
}
