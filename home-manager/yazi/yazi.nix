{...}: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    initLua = ./init.lua;
    settings = {
      manager = {
        show_hidden = true;
        sort_by = "natural";
        sort_sensitive = false;
        sort_dir_first = true;
      };
    };
  };
}
