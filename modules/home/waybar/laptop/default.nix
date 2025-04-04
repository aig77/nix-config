{ pkgs, ... }: {
  
  imports = [ ./style.nix ];

  programs.waybar = {
    #style = ./style.css;
    settings = {
      mainBar = {
        layer = "top";
        reload_style_on_change = true;

        modules-left = [
          "group/navigation"
        ];

        modules-center = [];

        modules-right = [
          "clock"
          "group/hardware"
          "group/systray"
          "custom/pipewire"
          "custom/exit"
        ];

        "group/navigation" = {
          orientation = "horizontal";
          modules = [
            "hyprland/workspaces"
            "hyprland/window"
          ];
        };

        "hyprland/workspaces" = {
          persistent-workspaces = {
            eDP-1 = [ 1 2 3 4 ];
          };
          on-click = "activate";
          sort-by-number = true;
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
          };
        };

        "hyprland/window" = {
            format = " {title}";
            max-length = 50;
            separate-outputs = true;
        };

        "wlr/taskbar" = {
            format = "{icon}";
            icon-size = 18;
            spacing = 0;
            all-outputs = true;
            on-click = "activate";
            on-click-right = "close";
        };

        "clock" = {
          format = "  {:%a, %b %d %H:%M}";
          #format-alt = "{:%A, %B %d, %Y (%R)}  ";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions =  {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };
        
        #"network" = {
        #  format = "{bandwidthUpBits}  {bandwidthDownBits}";
        #  interval = 2;
        #};       

        "group/hardware" = {
          orientation = "horizontal";
          modules = [
            "disk"
            "cpu"
            "memory"
          ];
        };

        "disk" = {
          format = "{percentage_used}% 󰨣 /";
        };

        "cpu" = {
          format = "{usage}%  /";
          interval = 2;
        };

        "memory" = {
          format = "{percentage}%  ";
          interval = 2;
        };

        "group/systray" = {
          orientation = "horizontal";
          modules = [
            "network"
            "bluetooth"
            "battery"
          ];
        }; 

        "network" = {
          #interface = "wlp2s0";
          #format = "{icon}";
          format-wifi = "{icon}";
          format-ethernet = "󰈁";
          format-disconnected = "󰤭";  # An empty format will hide the module.
          format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
          tooltip-format = "{ifname} via {gwaddr} 󰊗";
          tooltip-format-wifi = "{essid} ({signalStrength}%) ";
          tooltip-format-ethernet = "{ifname} ";
          tooltip-format-disconnected = "Disconnected";
          interval = 10;
          max-length = 50;
          on-click = "nm-connection-editor";
        };

        "bluetooth" = {
          # "controller": "controller1", // specify the alias of the controller if there are more than 1 on the system
          format = "";
          format-disabled = "󰂲"; # an empty format will hide the module
          format-connected = "";
          tooltip-format = "{controller_alias}\t{controller_address}\t{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
          on-click = "blueman-manager";
        };

        "battery" = {
          interval = 2;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}";
          format-icons = [ "" "" "" "" "" ];
          format-charging = "";
          format-full = "";
          tooltip = true;
          tooltip-format = "{capacity}% | {timeTo}";
          max-length = 25;
        };
                
        "custom/pipewire" = {
          tooltip = false;
          max-length = 6;   
          exec = pkgs.writeShellScript "run-pipewire" ''
            $HOME/nix/modules/home/waybar/laptop/pipewire.sh
          '';
          on-click = "pavucontrol";
          on-click-right = "qpwgraph";
        };

        "custom/exit" = {
          format = "⏻ ";
          on-click = "wlogout";
          tooltip = false;
        };
      };
    };
  };
}
