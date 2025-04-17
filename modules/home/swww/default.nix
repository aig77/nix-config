{ pkgs, inputs, ... }: {
  home.packages = with pkgs; [ inputs.swww.packages.${pkgs.system}.swww ];
}
