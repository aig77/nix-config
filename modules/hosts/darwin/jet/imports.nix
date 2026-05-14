{config, ...}: {
  configurations.darwin.jet.module = {
    imports = with config.flake.modules.darwin; [base];
  };
}
