{ config, ... }:
let
  colors = config.lib.stylix.colors.withHashtag;
  backgrounddark = colors.base00;
  backgroundlight = colors.base06;
  textcolor1 = colors.base07;
  highlighted = colors.base0A;
  font = config.stylix.fonts.monospace.name;
  iconPath = "/home/arturo/nix/modules/home/wlogout/icons";
in {
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "hyprlock";
        text = "";
        keybind = "l";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "";
        keybind = "h";
      }
      {
        label = "logout";
        action = "sleep 1; hyprctl dispatch exit";
        text = "";
        keybind = "e";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "";
        keybind = "s";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "";
        keybind = "u";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "";
        keybind = "r";
      }
    ];

    style = ''
      @define-color backgroundlight ${backgroundlight};
      @define-color backgrounddark ${backgrounddark};
      @define-color textcolor1 ${textcolor1};
      @define-color highlighted ${highlighted};

      * {
          font-family: ${font};
          background-image: none;
          transition: 20ms;
      }
      window {
          background-color: rgba(0,0,0,0.7);
          /*filter: blur(2px);*/
      }

      button {
          color: @textcolor1;
          background-color: @backgrounddark;
          border: 2px solid @backgroundlight;
          border-radius: 20px;
          margin: 10px;
          background-repeat: no-repeat;
          background-position: center;
          background-size: 25%;
          box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2) 0 6px 20px 0 rgba(0,0,0,0.19);
      }

      button:focus, button:active, button:hover {
          background-color: @backgrounddark;
          border-color: @highlighted;
          /*opacity: 0.8;*/
          outline-style: none;
          margin: 2px;
      }

      #lock {
          background-image: image(url("${iconPath}/lock.svg"));
      }

      #logout {
          background-image: image(url("${iconPath}/logout.svg"));
      }

      #suspend {
          background-image: image(url("${iconPath}/suspend.svg"));
      }

      #hibernate {
          background-image: image(url("${iconPath}/hibernate.svg"));
      }

      #shutdown {
          background-image: image(url("${iconPath}/shutdown.svg"));
      }

      #reboot {
          background-image: image(url("${iconPath}/reboot.svg"));
      }
    '';
  };
}
