_: {
  flake.modules.homeManager.noctalia = {
    inputs,
    pkgs,
    ...
  }: {
    imports = [inputs.noctalia.homeModules.default];
    programs.noctalia = {
      enable = true;
      systemd.enable = true;
    };
    home.packages = with pkgs; [playerctl brightnessctl];
  };
}
