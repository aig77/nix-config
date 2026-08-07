_: {
  flake.modules.nixos.actual-budget = {config, ...}: {
    var.services.actual-budget = {
      subdomain = "budget";
      port = config.ports.actualBudget;
      public = false;
      auth = false;
      backup.paths = ["/var/lib/actual"];
      monitor = {
        enable = true;
        type = "http";
      };
      homepage = {
        enable = true;
        title = "Actual Budget";
        icon = "si:actualbudget";
      };
    };

    services.actual = {
      enable = true;
      settings = {
        port = config.ports.actualBudget;
        hostname = "127.0.0.1";
      };
    };
  };
}
