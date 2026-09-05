_: {
  flake.modules.nixos.protonvpn = {pkgs, ...}: {
    networking = {
      wg-quick.interfaces = {
        protonvpn = {
          configFile = "/etc/wireguard/protonvpn.conf";
          autostart = false;
        };
      };
      firewall.checkReversePath = "loose";
    };
    environment.systemPackages = with pkgs; [
      wireguard-tools
      (pkgs.writeShellScriptBin "protonvpn" ''
        if systemctl is-active --quiet wg-quick-protonvpn; then
          sudo systemctl stop wg-quick-protonvpn
          echo "VPN disconnected"
        else
          sudo systemctl start wg-quick-protonvpn
          echo "VPN connected"
        fi
      '')
    ];
  };
}
