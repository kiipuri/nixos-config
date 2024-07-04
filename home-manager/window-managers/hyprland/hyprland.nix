{
  pkgs,
  hyprland,
  inputs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.default;
    systemd.enable = true;
    plugins = [
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
    settings = {
      workspace = [1 2 3 4 5 6 7 8 9];
      monitor = [
        "DP-3,preferred,0x0,1"
        "HDMI-A-2,preferred,auto-right,1"
      ];
      exec-once = [
        "pypr"
        "fcitx5"
        "${pkgs.swayidle}/bin/swayidle -w timeout 900 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'"
      ];
      input = {
        kb_layout = "us";
        kb_variant = "de_se_fi";
        kb_options = "caps:escape";
        follow_mouse = true;
        sensitivity = 0;
      };
      general = {
        gaps_in = 10;
        gaps_out = 20;
        border_size = 4;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };
      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 10;
          passes = 3;
          brightness = 1.1;
          noise = 0.2;
        };
        drop_shadow = true;
        shadow_range = 20;
        shadow_render_power = 2;
        "col.shadow" = "rgba(1a1a1aee)";
      };
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      master = {
        new_status = "master";
      };
      gestures = {
        workspace_swipe = false;
      };
      "$mainMod" = "SUPER";
      windowrule = [
        "float, qalculate-gtk"
      ];
      "$scratchpad" = "class:^(kitty-dropterm)$";
      "$pavucontrol" = "class:^(pavucontrol)$";
      windowrulev2 = [
        "opacity 0.9, class:(kitty)"
        "float, $scratchpad"
        "workspace special silent, $scratchpad"

        "float, $pavucontrol"
        "workspace special silent, $pavucontrol"
      ];
      bind = [
        "$mainMod, Return, exec, kitty"
        "$mainMod SHIFT, C, killactive,"
        "$mainMod SHIFT, Q, exit,"
        "$mainMod, G, togglefloating,"
        "$mainMod, P, exec, rofi -show drun"
        "$mainMod, H, resizeactive, -100 0"
        "$mainMod, L, resizeactive, 100 0"
        "$mainMod CONTROL, H, movewindow, l"
        "$mainMod CONTROL, L, movewindow, r"
        "$mainMod CONTROL, K, movewindow, u"
        "$mainMod CONTROL, J, movewindow, d"
        "$mainMod, F, fullscreen"

        # Move focus with mainMod + arrow keys
        "bind = $mainMod, H, movefocus, l"
        "bind = $mainMod, L, movefocus, r"
        "bind = $mainMod, K, movefocus, u"
        "bind = $mainMod, J, movefocus, d"

        # pyprland binds
        "$mainMod SHIFT, Z, exec, pypr zoom"
        "$mainMod SHIFT, L, exec, pypr toggle_dpms"
        "$mainMod, T, exec, pypr toggle term && hyprctl dispatch bringactivetotop"
        "$mainMod, Y, exec, pypr toggle volume && hyprctl dispatch bringactivetotop"
        "$mainMod, O, exec, pypr toggle music && hyprctl dispatch bringactivetotop"
        "$mainMod, C, exec, pypr toggle calc && hyprctl dispatch bringactivetotop"

        ", Print, exec, grim -g \"$(slurp -ow 0)\" - | wl-copy"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, split-workspace, 1"
        "$mainMod, 2, split-workspace, 2"
        "$mainMod, 3, split-workspace, 3"
        "$mainMod, 4, split-workspace, 4"
        "$mainMod, 5, split-workspace, 5"
        "$mainMod, 6, split-workspace, 6"
        "$mainMod, 7, split-workspace, 7"
        "$mainMod, 8, split-workspace, 8"
        "$mainMod, 9, split-workspace, 9"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, split-movetoworkspacesilent, 1"
        "$mainMod SHIFT, 2, split-movetoworkspacesilent, 2"
        "$mainMod SHIFT, 3, split-movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4, split-movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5, split-movetoworkspacesilent, 5"
        "$mainMod SHIFT, 6, split-movetoworkspacesilent, 6"
        "$mainMod SHIFT, 7, split-movetoworkspacesilent, 7"
        "$mainMod SHIFT, 8, split-movetoworkspacesilent, 8"
        "$mainMod SHIFT, 9, split-movetoworkspacesilent, 9"

        # Scroll through existing workspaces with mainMod + scroll
        "bind = $mainMod, mouse_down, workspace, e+1"
        "bind = $mainMod, mouse_up, workspace, e-1"

        "bind = $mainMod, N, workspace, r+1"
        "bind = $mainMod, V, workspace, r-1"

        "bind = $mainMod, comma, focusmonitor, 1"
        "bind = $mainMod, period, focusmonitor, 0"
      ];
      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };
  xdg = {
    enable = true;
    configFile = {
      pypr = {
        source = ./pyprland.toml;
        target = "hypr/pyprland.toml";
      };
    };
  };
}
