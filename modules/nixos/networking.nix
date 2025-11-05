{
  networking = {
    # Set DNS servers in priority order
    nameservers = [
      "192.168.1.69" # Pi-hole on Ethernet
      "192.168.1.70" # Pi-hole on WiFi
      "1.1.1.1" # Cloudflare fallback
      "8.8.8.8" # Google fallback
    ];

    # Prevent NetworkManager from overriding
    networkmanager.dns = "none";
  };
}
