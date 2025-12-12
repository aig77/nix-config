{...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 10;
          y = 10;
        };
        # opacity = lib.mkForce (
        #   if pkgs.stdenv.isDarwin
        #   then 1.0
        #   else 0.80
        # );
      };
    };
  };
}
