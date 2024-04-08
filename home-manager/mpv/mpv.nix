{pkgs, ...}: {
  programs.mpv = {
    enable = true;
    bindings = {
      "Ctrl+l" = "set loop-file inf";
      "Ctrl+R" = "cycle_values video-rotate 90 180 270 0";
      "]" = "add speed 0.1";
      "[" = "add speed -0.1";
      "MBTN_LEFT_DBL" = "ignore";
    };
    config = {
      volume = "50";
      ytdl-format = "bestvideo+bestaudio";
      ytdl-raw-options = "write-sub=,write-auto-sub=";
      cache = true;
      demuxer-max-bytes = "1G";
      profile = "pseudo-gui";
    };
    scripts = with pkgs.mpvScripts; [
      mpvacious
      uosc
      sponsorblock
      thumbfast
    ];
    scriptOpts = {
      uosc = {
        volume = "left";
        top_bar_controls = false;
      };
    };
  };
}
