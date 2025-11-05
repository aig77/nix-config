{
  services.avahi = {
    enable = true;
    nssmdns = true;
    publish.enable = true;
    publish.userServices = true;
  };

  networking.firewall.allowedUDPPorts = [5353];
}
