{
  inputs,
  lib,
  ...
}: {
  imports = [inputs.nixcord.homeModules.nixcord];

  programs.nixcord = {
    enable = true;
    config = {
      frameless = true;
      plugins = {
        noTrack.enable = true; # Disable Discord telemetry & analytics tracking
        alwaysAnimate.enable = true; # Keep all Discord animations smooth (no skipped frames)
        betterFolders.enable = true; # Collapse/expand server folders + optional unread counts
        callTimer.enable = true; # Show duration of active voice/video calls
        fakeNitro.enable = true; # Use custom emotes, animated emojis & HQ uploads without Nitro
        imageZoom.enable = true; # Zoom images/GIFs with scroll or pinch gestures
        readAllNotificationsButton.enable = true; # Add "mark all as read" button to clear notifications
      };
    };
  };

  # --------------------------------------------------------------------
  # Fix for nixcord Home-Manager activation failure:
  # The nixcord module runs `disableDiscordUpdates` during activation,
  # which edits ~/.config/discord/settings.json to stop Discord's auto-updater.
  # If you’ve never run stock Discord (e.g. only use Vesktop/Dorion),
  # that file won’t exist, so activation fails.
  #
  # This hook runs *before* disableDiscordUpdates, ensuring the directory
  # and file exist with SKIP_HOST_UPDATE=true so nixcord can proceed cleanly.
  # --------------------------------------------------------------------
  home.activation.ensureDiscordSettings = lib.hm.dag.entryBefore ["disableDiscordUpdates"] ''
    dir="$HOME/.config/discord"
    file="$dir/settings.json"
    mkdir -p "$dir"
    [ -f "$file" ] || printf '{"SKIP_HOST_UPDATE":true}\n' > "$file"
  '';
}
