{config, ...}: {
  wayland.windowManager.hyprland.settings = {
    bind = [
      # Shortcuts
      "SUPER, RETURN, exec, ${config.var.terminal}"
      "SUPER, SPACE, exec, ${config.var.launcher}"
      "SUPER, E, exec, ${config.var.file-manager}"
      "SUPER Control, Q, exec, ${config.var.lock}"
      "SUPER, X, exec, ${config.var.logout}"
      "SUPER, I, exec, ${config.var.browser}"

      # Hypr binds
      "SUPER, W, killactive"
      #"SUPER SHIFT, Q, exit"
      "SUPER, T, togglefloating"
      "SUPER, P, pseudo"
      "SUPER, O, togglesplit"
      "SUPER, F, fullscreen, 0"
      "SUPER SHIFT, F, fullscreen, 1"
      "SUPER, H, movefocus, l"
      "SUPER, J, movefocus, d"
      "SUPER, K, movefocus, u"
      "SUPER, L, movefocus, r"
      "SUPER, tab, cyclenext"
      "SUPER, 1, workspace, 1"
      "SUPER, 2, workspace, 2"
      "SUPER, 3, workspace, 3"
      "SUPER, 4, workspace, 4"
      "SUPER, 5, workspace, 5"
      "SUPER, 6, workspace, 6"
      "SUPER, 7, workspace, 7"
      "SUPER, 8, workspace, 8"
      "SUPER SHIFT, 1, movetoworkspace, 1"
      "SUPER SHIFT, 2, movetoworkspace, 2"
      "SUPER SHIFT, 3, movetoworkspace, 3"
      "SUPER SHIFT, 4, movetoworkspace, 4"
      "SUPER SHIFT, 5, movetoworkspace, 5"
      "SUPER SHIFT, 6, movetoworkspace, 6"
      "SUPER SHIFT, 7, movetoworkspace, 7"
      "SUPER SHIFT, 8, movetoworkspace, 8"
      "SUPER, S, togglespecialworkspace, magic"
      "SUPER SHIFT, S, movetoworkspace, special:magic"
      "SUPER, mouse_down, workspace, e+1"
      "SUPER, mouse_up, workspace, e-1"
    ];

    bindm = ["SUPER, mouse:272, movewindow" "SUPER, mouse:273, resizewindow"];
  };
}
