_: {
  flake.modules.nixos.subtrakr = {config, ...}: {
    var.services.subtrakr = {
      subdomain = "subtrakr";
      port = config.ports.subtrakr;
      public = false;
      auth = false;
      backup.paths = ["/var/lib/subtrakr"];
    };

    virtualisation = {
      podman.enable = true;
      oci-containers.containers = {
        subtrakr = {
          image = "ghcr.io/bscott/subtrackr:latest";
          ports = ["127.0.0.1:${toString config.ports.subtrakr}:8080"];
          volumes = ["/var/lib/subtrakr:/app/data"];
          environment = {
            GIN_MODE = "release";
            DATABASE_PATH = "/app/data/subtrakr.db";
          };
        };
      };
    };
  };
}
