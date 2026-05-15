{
  flake.modules.homeManager.brave = {pkgs, ...}: {
    programs.chromium = {
      enable = false;
      package = pkgs.brave;
      extensions = [
        {id = "nngceckbapebfimnlniiiahkandclblb";} # bitwarden
        {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # dark reader
      ];
    };
  };
}
