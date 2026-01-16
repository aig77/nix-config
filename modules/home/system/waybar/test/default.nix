{pkgs, ...}: {
  home.packages = [pkgs.cava];

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 40;
        spacing = 8;

        modules-left = [];
        modules-center = [
          "hyprland/workspaces"
          "custom/separator"
          "cava"
          "custom/separator"
          "group/right-pill"
        ];
        modules-right = [];

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "";
            default = "";
          };
        };

        "custom/separator" = {
          format = "";
          tooltip = false;
        };

        cava = {
          bars = 12;
          bar_delimiter = 0;
          format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
        };

        "group/right-pill" = {
          orientation = "horizontal";
          modules = [
            "clock"
            "wireplumber"
            "network"
            "custom/power"
          ];
        };

        clock = {
          format = " {:%H:%M}";
          tooltip-format = "{:%A, %B %d, %Y}";
        };

        wireplumber = {
          format = "{icon}";
          format-muted = "󰖁";
          scroll-step = 5.0;
          max-volume = 150.0;
          on-click = "pavucontrol";
          on-click-right = "qpwgraph";
          format-icons = ["󰕿" "󰖀" "󰕾"];
          tooltip-format = "{volume}% {node_name}";
        };

        network = {
          format-wifi = "";
          format-ethernet = "󰈀";
          format-disconnected = "󰖪";
          tooltip-format = "{essid} ({signalStrength}%)";
        };
      };

      "custom/power" = {
        format = "⏻";
        on-click = "wlogout";
        tooltip = false;
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
      }

      /* Pill styling */
      #workspaces,
      #cava,
      #custom-power.right-pill {
        background: rgba(30, 30, 46, 0.8);
        border-radius: 20px;
        padding: 4px 16px;
        margin: 4px 0;
      }

      #workspaces button {
        padding: 0 8px;
        color: #cdd6f4;
        border-radius: 10px;
        transition: all 0.3s;
      }

      #workspaces button.active {
        color: #89b4fa;
        background: rgba(137, 180, 250, 0.2);
      }

      #workspaces button:hover {
        background: rgba(255, 255, 255, 0.1);
      }

      /* Cava pill */
      #cava {
        color: #89b4fa;
        padding: 4px 12px;
      }

      /* Right pill group */
      .modules-right > * {
        background: rgba(30, 30, 46, 0.8);
        border-radius: 20px;
        padding: 4px 16px;
        margin: 4px 0;
      }

      #clock,
      #pulseaudio,
      #network,
      #custom-power {
        color: #cdd6f4;
        padding: 0 8px;
      }

      #custom-power {
        color: #f38ba8;
        padding-left: 12px;
      }

      #custom-power:hover {
        color: #eba0ac;
      }

      /* Separator - invisible spacer */
      #custom-separator {
        color: transparent;
        padding: 0 4px;
      }
    '';
  };
}
