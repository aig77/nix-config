_: {
  flake.modules.homeManager.wlsunset = {lib, ...}: {
    services.wlsunset = {
      enable = true;
      # sunrise/sunset are required by the module. Setting sunset to 23:59
      # makes almost the entire day "nighttime", so night temp always applies.
      sunrise = "00:01";
      sunset = "23:59";
      # 1 K apart -- the minimum valid gap. Filter is effectively constant at 5000 K.
      temperature.day = 5001;
      temperature.night = 5000;
    };

    # Strip the WantedBy target so the service never autostarts.
    # Must be triggered manually using systemctl --user start/stop wlsunset
    systemd.user.services.wlsunset.Install.WantedBy = lib.mkForce [];
  };
}
