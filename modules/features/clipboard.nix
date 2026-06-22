_: {
  flake.modules.homeManager.clipboard = {pkgs, ...}: {
    home.packages = with pkgs; [cliphist wl-clipboard wtype];

    systemd.user.services.cliphist = {
      Unit = {
        Description = "cliphist clipboard history daemon";
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
        Restart = "on-failure";
        RestartSec = "3s";
      };
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
