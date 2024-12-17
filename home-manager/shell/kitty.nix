{
  programs.kitty = {
    enable = true;
    extraConfig = ''
      map f1 launch --cwd=current --type=background kitty
    '';
    settings = {
      window_padding_width = 10;
      font_size = 16;
      confirm_os_window_close = 0;
      enable_audio_bell = "no";
    };
    shellIntegration = {
      enableZshIntegration = true;
      mode = "no-sudo";
    };
  };
}
