{
  security.rtkit.enable = true;
  # <= 24.11
  #hardware.pulseaudio.enable = false;

  # > 24.11
  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };
}
