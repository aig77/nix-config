_: {
  flake.modules.nixos.ly = _: {
    services.displayManager.ly = {
      enable = true;
      settings = {
        session_log = ".local/state/ly/session.log";
        clock = "%a %b %d";
        bigclock = "en";
        hide_keyboard_locks = true;
        hide_version_string = true;
      };
    };
  };
}
