{pkgs, ...}: {
  home.packages = with pkgs; [
    protonmail-bridge
    mailspring # Modern alternative to Thunderbird
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
