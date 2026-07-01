_: {
  flake.modules.homeManager.claude = {pkgs, ...}: {
    home.packages = [pkgs.nodejs pkgs.nixd];

    programs.claude-code = {
      enable = true;
      plugins = [
        # update with claude plugin update caveman
        (pkgs.fetchFromGitHub {
          owner = "JuliusBrussee";
          repo = "caveman";
          rev = "63e797cd753b";
          hash = "sha256-pHPMQGr9/ufsUODmqHm2T6sCOaeOOJl4baX4OeeYp6k=";
        })
      ];
      skills.new-project = ./skills/new-project.md;
      mcpServers.nixos = {
        type = "stdio";
        command = "nix";
        args = ["run" "github:utensils/mcp-nixos" "--"];
      };
      lspServers.nix = {
        command = "nixd";
        args = [];
        extensionToLanguage = {
          ".nix" = "nix";
        };
      };
    };
  };
}
