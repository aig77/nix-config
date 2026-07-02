_: {
  flake.modules.homeManager.waypaper = {
    pkgs,
    lib,
    ...
  }: let
    wallpaper-picker = pkgs.writeShellScriptBin "wallpaper-picker" ''
      exec ${pkgs.waypaper}/bin/waypaper
    '';
  in {
    home.packages = [pkgs.waypaper wallpaper-picker];

    # Write config only if it doesn't exist — waypaper updates the wallpaper= line
    # at runtime, so a Nix-managed symlink (immutable) would prevent it from saving state.
    home.activation.waypaperConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
            config="$HOME/.config/waypaper/config.ini"
            if [ ! -f "$config" ]; then
              mkdir -p "$(dirname "$config")"
              cat > "$config" <<'EOF'
      [Settings]
      folder = ~/Pictures/Wallpapers
      wallpaper =
      backend = awww
      monitors = All
      fill = fill
      sort = name
      subfolders = False
      number_of_columns = 4
      post_command = cp $wallpaper $HOME/.cache/bebop/current-wallpaper
      EOF
            fi
    '';
  };
}
