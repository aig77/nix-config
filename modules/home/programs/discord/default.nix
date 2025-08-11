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

  # Ensure correct settings.json exists before nixcord runs
  home.activation.ensureDiscordSettings = lib.hm.dag.entryBefore ["disableDiscordUpdates"] ''
    if [ "$(uname)" = "Darwin" ]; then
      dir="$HOME/Library/Application Support/discord"
    else
      dir="$HOME/.config/discord"
    fi

    file="$dir/settings.json"
    mkdir -p "$dir"
    if [ ! -f "$file" ]; then
      printf '{"SKIP_HOST_UPDATE":true}\n' > "$file"
    fi
  '';
}
