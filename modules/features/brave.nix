{
  flake.modules.homeManager.brave = {pkgs, ...}: {
    programs.chromium = {
      enable = true;
      package = pkgs.brave;
      extensions = [
        {id = "nngceckbapebfimnlniiiahkandclblb";} # bitwarden
        {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # dark reader
      ];
    };
  };
}
