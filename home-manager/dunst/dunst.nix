{...}: {
  services.dunst = {
    global = {
      monitor = 0;
      follow = "keyboard";
      width = 400;
      height = 300;
      origin = "top-right";
      offset = "25x55";
      scale = 0;
      notification_limit = 0;
      progress_bar = true;
      progress_bar_height = 10;
      progress_bar_frame_width = 1;
      progress_bar_min_width = 150;
      progress_bar_max_width = 300;
      indicate_hidden = true;
      transparency = 0;
      separator_height = 1;
      padding = 10;
      horizontal_padding = 8;
      text_icon_padding = 0;
      frame_width = 4;
      frame_color = "#caccfa";
      separator_color = "frame";
      sort = true;
      font = "Comfortaa 16";
      line_height = 0;
      markup = "full";
      format = "<b>%s</b>\n%b";
      alignment = "center";
      vertical_alignment = "center";
      show_age_threshold = 60;
      ellipsize = "middle";
      ignore_newline = false;
      stack_duplicates = true;
      hide_duplicate_count = false;
      show_indicators = true;
      icon_position = "left";
      min_icon_size = 32;
      max_icon_size = 32;
      sticky_history = true;
      history_length = 20;
      title = "Dunst";
      class = "Dunst";
      corner_radius = 5;
      ignore_dbusclose = false;
      force_xwayland = false;
      force_xinerama = false;
      mouse_left_click = "close_current";
      mouse_middle_click = "do_action, close_current";
      mouse_right_click = "close_all";
    };

    urgency_low = {
      background = "#1a1e2b";
      foreground = "#caccfa";
      timeout = 5;
    };

    urgency_normal = {
      background = "#1a1e2b";
      foreground = "#caccfa";
      timeout = 5;
    };
  };
}
