{config, ...}: let
  inherit (config.flake.meta.owner) username;
  hm = config.flake.modules.homeManager;
  inherit (config.flake.modules) nixos;
in {
  flake.modules.nixos.hyprland-quickshell = _: {
    imports = [nixos.hyprland];
    var.launcher = "quickshell";
    home-manager.users.${username}.imports = [
      hm.hyprland
      hm.quickshellShell
      hm.screenshot
      {
        wayland.windowManager.hyprland.settings.exec-once = ["quickshell"];
        wayland.windowManager.hyprland.settings.bindd = [
          "ALT, tab, Workspace Overview, exec, qs ipc call overview toggle"
        ];
      }
    ];
  };
}
