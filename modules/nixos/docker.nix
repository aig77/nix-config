{lib, ...}: {
  virtualisation.docker = {
    enable = false;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  systemd.user.services.docker = {
    enable = true;
    # This key line forces the daemon to wait for a command.
    wantedBy = lib.mkForce [];
  };
}
