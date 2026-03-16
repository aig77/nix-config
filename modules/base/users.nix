{
  flake.nixosModules.users = {
    pkgs,
    config,
    ...
  }: let
    inherit (config.var) shell username;
  in {
    environment.shells = with pkgs; [fish zsh];
    programs.${shell}.enable = true;

    users.users = {
      ${username} = {
        isNormalUser = true;
        initialPassword = "password";
        extraGroups = ["wheel" "networkmanager"];
        shell = pkgs.${shell};
      };
    };
  };
}
