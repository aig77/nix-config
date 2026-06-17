_: {
  flake.modules.homeManager.fish = {
    pkgs,
    lib,
    var,
    config,
    ...
  }:
    lib.mkIf (var.shell == "fish") {
      programs.fish = {
        enable = true;

        shellAliases = {
          ll = "ls -l";
          ls = "eza --icons=always --no-quotes";
          tree = "eza --icons=always --tree --no-quotes";
          cat = "bat --theme=base16 --color=always --wrap=never";
        };

        functions =
          lib.optionalAttrs pkgs.stdenv.isDarwin {
            drs.body = ''
              if test "$argv[1]" = help
                echo "Usage: drs [host] [args]"
                echo "  drs        rebuild current host"
                echo "  drs ein    rebuild ein"
                return
              end
              set h $argv[1]; set rest $argv[2..]
              set flake "${var.repoPath}"; test -n "$h"; and set flake "${var.repoPath}#$h"
              sudo darwin-rebuild switch --flake $flake $rest
            '';
            nrs.body = ''
              if test "$argv[1]" = help
                echo "Usage: nrs [host] [args]"
                echo "  nrs spike    rebuild spike"
                echo "  nrs faye     rebuild faye"
                return
              end
              set h $argv[1]; set rest $argv[2..]
              set flake "${var.repoPath}"; test -n "$h"; and set flake "${var.repoPath}#$h"
              sudo nixos-rebuild switch --flake $flake $rest
            '';
          }
          // lib.optionalAttrs pkgs.stdenv.isLinux {
            nrs.body = ''
              if test "$argv[1]" = help
                echo "Usage: nrs [host] [args]"
                echo "  nrs                                                      rebuild current host"
                echo "  nrs faye                                                 rebuild faye locally"
                echo "  nrs jet --target-host user@jet --sudo --ask-password    rebuild jet remotely"
                return
              end
              set h $argv[1]; set rest $argv[2..]
              set flake "${var.repoPath}"; test -n "$h"; and set flake "${var.repoPath}#$h"
              sudo nixos-rebuild switch --flake $flake $rest
            '';
            nrt.body = ''
              if test "$argv[1]" = help
                echo "Usage: nrt [host] [args]"
                echo "  nrt                                                      test current host"
                echo "  nrt faye                                                 test faye locally"
                echo "  nrt jet --target-host user@jet --sudo --ask-password    test jet remotely"
                return
              end
              set h $argv[1]; set rest $argv[2..]
              set flake "${var.repoPath}"; test -n "$h"; and set flake "${var.repoPath}#$h"
              sudo nixos-rebuild test --flake $flake $rest
            '';
          };

        interactiveShellInit = ''
          set -g fish_greeting ""

          fish_vi_key_bindings

          bind -M insert \e\[A history-search-backward
          bind -M insert \e\[B history-search-forward
          bind \e\[A history-search-backward
          bind \e\[B history-search-forward

          bind -M insert \cp history-search-backward
          bind -M insert \cn history-search-forward
          bind \cp history-search-backward
          bind \cn history-search-forward

          if type -q fzf_configure_bindings
            fzf_configure_bindings --directory=\ct --git_log=\cl --git_status=\cg --history=\cr
          end

          set -U fish_history_save all
        '';

        shellInitLast = lib.mkIf (config.lib ? stylix) (
          let
            colors = config.lib.stylix.colors.withHashtag;
          in "set -g fish_color_param ${colors.base05}"
        );

        plugins = with pkgs.fishPlugins; [
          {inherit (fzf-fish) name src;}
          {inherit (autopair) name src;}
          {inherit (done) name src;}
          {inherit (sponge) name src;}
        ];
      };

      programs = {
        fzf.enableFishIntegration = true;
        ghostty.enableFishIntegration = true;
        starship.enableFishIntegration = true;
        zoxide.enableFishIntegration = true;
      };
    };
}
