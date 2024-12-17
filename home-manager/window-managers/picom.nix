{...}: {
  services.picom = {
    enable = true;
    shadow = true;
    backend = "glx";
    vSync = true;

    shadowOffsets = [
      (-20)
      0
    ];
    shadowOpacity = 0.9;

    shadowExclude = [
      "name = 'Notification'"
      "class_g = 'Conky'"
      "class_g ?= 'Notify-osd'"
      "class_g = 'Cairo-clock'"
      "_GTK_FRAME_EXTENTS@:c"
    ];
    fade = true;
    fadeSteps = [0.03 0.03];

    fadeDelta = 8;
    inactiveOpacity = 1;

    settings = {
      shadow-radius = 15;
      corner-radius = 20;
      blur-method = "dual_kawase";
      blur-strength = 4;
      use-damage = true;
      log-level = "warn";
      blur-kern = "3x3box";
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      detect-rounded-corners = true;
      detect-client-opacity = true;
      detect-transient = true;
      frame-opacity = 1.0;

      rounded-corners-exclude = [
        "class_g = 'Dunst'"
        "class_g = 'dwm'"
        "class_g = 'Rofi'"
        "name = '月姫'"
        "window_type = 'dropdown_menu'"
        "window_type = 'menu'"
        "window_type = 'utility'"
        "window_type = 'popup_menu'"
        "window_type = 'tooltip'"
      ];

      blur-background-exclude = [
        "class_g = 'slop'"
        "window_type = 'dock'"
        "window_type = 'desktop'"
        "_GTK_FRAME_EXTENTS@:c"
      ];
    };

    # wintypes:
    # {
    #   tooltip = { fade = true; shadow = true; opacity = 100; focus = true; full-shadow = false; };
    #   dock = { shadow = false; clip-shadow-above = true; }
    #   dnd = { shadow = false; }
    #   popup_menu = { opacity = 1; }
    #   dropdown_menu = { opacity = 1; }
    # };
  };
}
