{inputs, ...}: {
  imports = [inputs.nixcord.homeModules.nixcord];

  programs.nixcord = {
    enable = true;
    config = {
      frameless = true;
      plugins = {
        alwaysAnimate.enable = true; # Keep all Discord animations smooth (no skipped frames)
        betterFolders.enable = true; # Collapse/expand server folders + optional unread counts
        fakeNitro.enable = true; # Use custom emotes, animated emojis & HQ uploads without Nitro
        imageZoom.enable = true; # Zoom images/GIFs with scroll or pinch gestures
        readAllNotificationsButton.enable = true; # Add "mark all as read" button to clear notifications
        # Note: noTrack plugin was removed from Vencord - telemetry blocking may be built-in now
      };
    };
  };
}
