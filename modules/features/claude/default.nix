_: {
  flake.modules.homeManager.claude = {pkgs, ...}: {
    home.sessionVariables.CAVEMAN_DEFAULT_MODE = "full";

    home.packages = [
      pkgs.nodejs
      pkgs.nixd
      (pkgs.writeShellScriptBin "ccusage" ''
        exec ${pkgs.nodejs}/bin/npx ccusage@latest "$@"
      '')
    ];

    programs.claude-code = {
      enable = true;
      plugins = {
        caveman = pkgs.fetchFromGitHub {
          owner = "JuliusBrussee";
          repo = "caveman";
          rev = "63e797cd753b";
          hash = "sha256-pHPMQGr9/ufsUODmqHm2T6sCOaeOOJl4baX4OeeYp6k=";
        };
      };
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
