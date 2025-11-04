{pkgs, ...}: {
  programs.thunderbird = {
    enable = true;

    profiles."default" = {
      isDefault = true;

      # extensions = [ catppuccin-mocha-mauve ];

      settings = {
        "mail.default_html_action" = 3;
        "mail.show_headers" = 1;
        "privacy.donottrackheader.enabled" = true;
        "mailnews.message_display.disable_remote_image" = true;
        "mail.tabs.autoHide" = false;
      };
    };
  };

  home.packages = with pkgs; [
    protonmail-bridge
  ];

  systemd.user.services.protonmail-bridge = {
    Unit = {
      Description = "ProtonMail Bridge";
      After = ["network.target"];
    };
    Service = {
      ExecStart = "${pkgs.protonmail-bridge}/bin/protonmail-bridge --noninteractive";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = ["default.target"];
    };
  };
}
