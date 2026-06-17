{lib, ...}: {
  flake.modules.nixos.base = {
    options.ports = {
      glance = lib.mkOption {
        type = lib.types.port;
        default = 3000;
      };
      invidious = lib.mkOption {
        type = lib.types.port;
        default = 3010;
      };
      invidiousCompanion = lib.mkOption {
        type = lib.types.port;
        default = 3011;
      };
      invidiousStatus = lib.mkOption {
        type = lib.types.port;
        default = 3012;
      };
      n8n = lib.mkOption {
        type = lib.types.port;
        default = 3020;
      };
      grafana = lib.mkOption {
        type = lib.types.port;
        default = 3030;
      };
      gatus = lib.mkOption {
        type = lib.types.port;
        default = 3040;
      };
      prometheus = lib.mkOption {
        type = lib.types.port;
        default = 3050;
      };
      nodeExporter = lib.mkOption {
        type = lib.types.port;
        default = 3051;
      };
      dailyStoic = lib.mkOption {
        type = lib.types.port;
        default = 3060;
      };
      blockyHttp = lib.mkOption {
        type = lib.types.port;
        default = 4000;
      };
    };
  };
}
