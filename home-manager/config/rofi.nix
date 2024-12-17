{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.lib.formats.rasi) mkLiteral;
  theme = config.colorScheme;
  inherit (theme) palette;
in {
  # home.packages = [(pkgs.callPackage ../derivatives/vpn.nix {})];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    # plugins = [pkgs.rofi-vpn];
    extraConfig = {
      # modi = "run,drun,vpn:vpn";
      modi = "run,drun";
      icon-theme = "Oranchelo";
      show-icons = true;
      terminal = "kitty";
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 󰕰  Window ";
      display-network = " 󰤨  Network ";
      display-vpn = " 󰒘  VPN ";
      sidebar-mode = true;
      kb-accept-entry = "Return,KP_Enter";
      kb-remove-to-eol = "";
      kb-row-up = "Up,Control+k";
      kb-row-down = "Down,Control+j";
      kb-mode-complete = "";
      kb-element-next = "";
      kb-mode-next = "Tab";
      kb-remove-char-back = "BackSpace,Shift+BackSpace";
      kb-row-left = "Control+h";
      kb-row-right = "Control+l";
    };

    theme = lib.mkForce {
      "*" = {
        bg-col = mkLiteral "#${palette.base00}";
        bg-col-light = mkLiteral "#${palette.base00}";
        border-col = mkLiteral "#${palette.base00}";
        border-radius = 10;
        selected-col = mkLiteral "#${palette.base00}";
        blue = mkLiteral "#${palette.base0D}";
        fg-col = mkLiteral "#${palette.base05}";
        fg-col2 = mkLiteral "#${palette.base08}";
        grey = mkLiteral "#6e738d";

        width = 600;
      };

      "element-text, element-icon , mode-switcher" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      window = {
        height = mkLiteral "360px";
        border = mkLiteral "3px";
        border-color = mkLiteral "@border-col";
        background-color = mkLiteral "@bg-col";
      };

      network = {
        height = mkLiteral "360px";
        border = mkLiteral "3px";
        border-color = mkLiteral "@border-col";
        background-color = mkLiteral "@bg-col";
      };

      mainbox = {
        background-color = mkLiteral "@bg-col";
      };

      inputbar = {
        children = mkLiteral "[prompt,entry]";
        background-color = mkLiteral "@bg-col";
        border-radius = mkLiteral "5px";
        padding = mkLiteral "2px";
      };

      prompt = {
        background-color = mkLiteral "@blue";
        padding = mkLiteral "6px";
        text-color = mkLiteral "@bg-col";
        border-radius = mkLiteral "3px";
        margin = mkLiteral "20px 0px 0px 20px";
      };

      textbox-prompt-colon = {
        expand = mkLiteral "false";
        str = ":";
      };

      entry = {
        padding = mkLiteral "6px";
        margin = mkLiteral "20px 0px 0px 10px";
        text-color = mkLiteral "@fg-col";
        background-color = mkLiteral "@bg-col";
      };

      listview = {
        border = mkLiteral "0px 0px 0px";
        padding = mkLiteral "6px 0px 0px";
        margin = mkLiteral "10px 0px 0px 20px";
        columns = mkLiteral "2";
        lines = mkLiteral "5";
        background-color = mkLiteral "@bg-col";
      };

      element = {
        padding = mkLiteral "5px";
        background-color = mkLiteral "@bg-col";
        text-color = mkLiteral "@fg-col";
      };

      element-icon = {
        size = mkLiteral "25px";
      };

      "element selected" = {
        background-color = mkLiteral "@selected-col";
        text-color = mkLiteral "@fg-col2";
      };

      mode-switcher = {
        spacing = mkLiteral "0";
      };

      button = {
        padding = mkLiteral "10px";
        background-color = mkLiteral "@bg-col-light";
        text-color = mkLiteral "@grey";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.5";
      };

      "button selected" = {
        background-color = mkLiteral "@bg-col";
        text-color = mkLiteral "@blue";
      };

      message = {
        background-color = mkLiteral "@bg-col-light";
        margin = mkLiteral "2px";
        padding = mkLiteral "2px";
        border-radius = mkLiteral "5px";
      };

      textbox = {
        padding = mkLiteral "6px";
        margin = mkLiteral "20px 0px 0px 20px";
        text-color = mkLiteral "@blue";
        background-color = mkLiteral "@bg-col-light";
      };
    };
  };
}
