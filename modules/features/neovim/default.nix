_: {
  flake.modules.homeManager.neovim = {
    pkgs,
    # lib,
    config,
    osConfig,
    ...
  }:
  # let
  #   enableStylix = false; # toggle to enable stylix theming
  #   priority = 900; # set loading priority (themes default at 1000)
  # in {
  {
    stylix.targets.neovim.enable = false;

    # new nvim-treesitter rewrite builds parses from source using tree-sitter CLI
    home.packages = [pkgs.tree-sitter];

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      withRuby = true;
      withPython3 = true;
    };

    xdg.configFile."nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${osConfig.var.repoPath}/modules/features/neovim/nvim";

    # DEPRECATED
    # for now since its not in use
    #   # base16 themeing using stylix
    #   home.file = lib.mkIf enableStylix {
    #     ".config/nvim/lua/plugins/base16.lua".text = let
    #       colors = config.lib.stylix.colors.withHashtag;
    #     in ''
    #       return {
    #         "echasnovski/mini.base16",
    #         priority = ${toString priority},
    #         config = function()
    #           require('mini.base16').setup({ palette = {
    #             base00 = "${colors.base00}",
    #             base01 = "${colors.base01}",
    #             base02 = "${colors.base02}",
    #             base03 = "${colors.base03}",
    #             base04 = "${colors.base04}",
    #             base05 = "${colors.base05}",
    #             base06 = "${colors.base06}",
    #             base07 = "${colors.base07}",
    #             base08 = "${colors.base08}",
    #             base09 = "${colors.base09}",
    #             base0A = "${colors.base0A}",
    #             base0B = "${colors.base0B}",
    #             base0C = "${colors.base0C}",
    #             base0D = "${colors.base0D}",
    #             base0E = "${colors.base0E}",
    #             base0F = "${colors.base0F}",
    #           }})
    #         end
    #       }
    #     '';
    #   };
  };
}
