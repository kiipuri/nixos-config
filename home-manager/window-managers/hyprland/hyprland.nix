{
  pkgs,
  hyprland,
  inputs,
  ...
}: let
  pyprland-wrapper = final: prev: {
    my-pyprland = prev.pyprland.overrideAttrs (old: {
      # doCheck = true;
      postFixup = ''
        wrapProgram $out/bin/pypr \
        --set PATH ${prev.lib.makeBinPath [prev.kitty]}
      '';
    });
  };
  # pyprland-wrapper = pkgs.symlinkJoin {
  #   name = "pyprland";
  #   paths = with pkgs; [pyprland kitty];
  # };
  # pyprland-wrapper = pkgs.stdenv.mkDerivation {
  #   name = "pyprland";
  #   dontUnpack = true;
  #   buildInputs = with pkgs; [kitty];
  #   buildPhase = ''
  #     export PATH="${pkgs.kitty}/bin:$PATH"
  #   '';
  # };
in {
  # nixpkgs.overlays = [pyprland-wrapper];
  imports = [./pyprland.nix];
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
        "${pkgs.pyprland}/bin/pypr"
        # "${pkgs.my-pyprland}/bin/pypr"
        "${pkgs.fcitx5}/bin/fcitx5"
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
        shadow = {
          enabled = true;
          range = 20;
          render_power = 2;
          color = "rgba(1a1a1aee)";
        };
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
      "$pavucontrol" = "class:^(org.pulseaudio.pavucontrol)$";
      windowrulev2 = [
        "opacity 0.9, class:(kitty)"
        "float, $scratchpad"
        "workspace special silent, $scratchpad"

        "float, $pavucontrol"
        "workspace special silent, $pavucontrol"
      ];
      bind = [
        "$mainMod, Return, exec, ${pkgs.kitty}/bin/kitty"
        "$mainMod SHIFT, C, killactive,"
        "$mainMod SHIFT, Q, exit,"
        "$mainMod, G, togglefloating,"
        "$mainMod, P, exec, ${pkgs.rofi-wayland}/bin/rofi -show drun"
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
        "$mainMod SHIFT, Z, exec, ${pkgs.pyprland}/bin/pypr zoom"
        "$mainMod SHIFT, L, exec, ${pkgs.pyprland}/bin/pypr toggle_dpms"
        "$mainMod, T, exec, ${pkgs.pyprland}/bin/pypr toggle term && hyprctl dispatch bringactivetotop"
        "$mainMod, Y, exec, ${pkgs.pyprland}/bin/pypr toggle volume && hyprctl dispatch bringactivetotop"
        "$mainMod, O, exec, ${pkgs.pyprland}/bin/pypr toggle music && hyprctl dispatch bringactivetotop"
        "$mainMod, C, exec, ${pkgs.pyprland}/bin/pypr toggle calc && hyprctl dispatch bringactivetotop"

        ", Print, exec, ${pkgs.grim}/bin/grim -g \"$(slurp -ow 0)\" - | wl-copy"

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
  home.packages = with pkgs; [pyprland];
  # xdg = {
  #   enable = true;
  #   configFile = {
  #     pypr = {
  #       source = ./pyprland.toml;
  #       # text = builtins.readFile ./pyprland.toml;
  #       target = "hypr/pyprland.toml";
  #     };
  #   };
  # };
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
