{ lib, config, ... }:
let scheme = config.lib.stylix.colors.withHashtag;
in {
  programs.waybar.style = lib.mkForce ''
    @define-color background ${scheme.base06};
    @define-color workspacesbackground1 ${scheme.base00};
    @define-color workspacesbackground2 ${scheme.base00};
    @define-color workspacesbackground3 ${scheme.base01};
    @define-color bordercolor ${scheme.base06};
    @define-color textcolor1 ${scheme.base00};
    @define-color textcolor2 ${scheme.base06};
    @define-color textcolor3 ${scheme.base0B};
    @define-color textcolor4 ${scheme.base0D};
    @define-color textcolor5 ${scheme.base0F};
    @define-color iconcolor ${scheme.base03};

    * {
        font-family: JetBrainsMono Nerd Font, DejaVu Sans, DejaVu Serif;
        border: none;
        border-radius: 0px;
        font-size: 11px;
    }

    window#waybar {
        background-color: transparent;
        opacity: 0.95;
        transition-property: background-color;
        transition-duration: .5s;
    }

    #navigation {
      background-color: @background;
      margin: 4px 0px 4px 10px;
      color: @textcolor1;
      border-radius: 15px;
    }

    #workspaces {
        padding-left: 4px;
        color: transparent;
        font-size: 0px;
    }

    #workspaces button {
        padding: 0px;
        margin: 4px;
        border-radius: 20px;
        min-height: 0px;
        background-color: @workspacesbackground2;
        transition: all 0.3s ease-in-out;
        opacity: 0.4;
        font-size: 0px;
    }

    #workspaces button.active {
        background: @workspacesbackground2;
        transition: all 0.3s ease-in-out;
        min-width: 25px;
        opacity: 1.0;
    }

    #workspaces button:hover {
        background: @workspacesbackground3;
        opacity: 0.7;
    }

    #window {
        padding-left: 6px;
        padding-right: 10px;
        font-weight: bold;
    }

    window#waybar.empty #window {
        padding: 0px 8px;
    }

    #clock {
        background-color: transparent;
        margin: 4px 5px 4px 0px;
        padding-left: 15px;
        padding-right: 15px;
        border: 1.5px solid @background;
        border-radius: 15px;
        color: @textcolor2;
    }

    #hardware {
        background: transparent;
        margin: 4px 5px 4px 5px;
        border-radius: 15px;
        color: @textcolor2;
    }

    #disk {
        padding-left: 15px;
        padding-right: 2px;
    }

    #cpu {
        padding-left: 2px;
        padding-right: 2.5px;
    }

    #memory {
        padding-left: 2px;
        padding-right: 15px;
    }

    #systray {
        background-color: transparent;
        margin: 4px 5px 4px 5px;
        border: 1.5px solid @background;
        border-radius: 15px;
        color: @textcolor2;
    }

    #network {
        padding-left: 15px;
        padding-right: 10px;
    }

    #bluetooth {
        padding-left: 10px;
        padding-right: 10px;
    }

    #battery {
        padding-left: 7px;
        padding-right: 15px;
    }

    #battery.warning { color: orange; }
    #battery.critical { color: red; }

    #wireplumber {
        background-color: transparent;
        margin: 4px 17px 4px 1px;
        color: @textcolor2;
    }

    #custom-exit {
        background-color: @background;
        margin: 4px 10px 4px 5px;
        padding-left: 15px;
        padding-right: 10px;
        border-radius: 15px;
        color: @textcolor1;
    }
  '';
}
