_: {
  flake.modules.nixos.actual-budget = {config, ...}: {
    var.services.actual-budget = {
      subdomain = "budget";
      port = config.ports.actualBudget;
      public = false;
      auth = false;
      backup.paths = ["/var/lib/actual"];
    };

    services.actual = {
      enable = true;
      openFirewall = true;
      settings.port = config.ports.actualBudget;
    };
  };
}
