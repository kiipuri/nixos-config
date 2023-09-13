{
  config,
  pkgs,
  ...
}: let
  theme = config.colorScheme;
  inherit (theme) colors;
in {
  programs.waybar = {
    enable = true;
    style = ''
      /** ********** Fonts ********** **/
      * {
        font-family: "JetBrains Mono", "Iosevka Nerd Font", archcraft, sans-serif;
        font-size: 16px;
      }

      tooltip {
        color: #${colors.base05};
        background-color: #${colors.base00};
      }

      tooltip * {
        color: #${colors.base05};
        background-color: #${colors.base00};
      }

      window#waybar {
        background-color: #${colors.base00};
      }
      /** ********** Clock ********** **/
      #clock {
        background-color: #a6e3a1;
      }

      /** ********** CPU ********** **/
      #cpu {
        background-color: #89dceb;
      }

      /** ********** Memory ********** **/
      #memory {
        background-color: #eba0ac;
      }

      /** ********** Disk ********** **/
      #disk {
        background-color: #b4befe;
      }
      /** ********** Pulseaudio ********** **/
      #pulseaudio {
        background-color: #fab387;
      }

      #pulseaudio.bluetooth {
        background-color: #f5c2e7;
      }
      #pulseaudio.muted {
        background-color: #313244;
        color: #cdd6f4;
      }

      /** ********** Network ********** **/
      #network {
        background-color: #89b4fa;
      }

      #network.disconnected,
      #network.disabled {
        background-color: #313244;
        color: #cdd6f4;
      }
      #network.linked {
      }
      #network.ethernet {
      }
      #network.wifi {
      }

      /** ********** Custom ********** **/
      #custom-menu,
      #custom-power,
      #custom-weather,
      #custom-updater {
        border-radius: 4px;
        margin: 6px 0px;
        padding: 2px 8px;
      }

      #custom-menu {
        background-color: #f5c2e7;
        margin-left: 6px;
        padding: 2px 6px;
        font-size: 16px;
      }

      #custom-power {
        background-color: #f38ba8;
        margin-right: 6px;
        padding: 2px 8px;
        font-size: 16px;
      }

      #custom-updater {
        background-color: #e6ed7b;
        margin-right: 6px;
        padding: 2px 8px;
        font-size: 12px;
      }

      #custom-weather {
        background-color: #cba6f7;
        margin-right: 6px;
        padding: 2px 8px;
        font-size: 12px;
      }

      /** Common style **/
      #backlight,
      #battery,
      #clock,
      #cpu,
      #disk,
      #mode,
      #memory,
      #mpd,
      #tray,
      #pulseaudio,
      #network {
        border-radius: 4px;
        margin: 6px 0px;
        padding: 2px 8px;
        color: #${colors.base00};
      }

      button:hover {
        box-shadow: none; /* Remove predefined box-shadow */
        text-shadow: none; /* Remove predefined text-shadow */
        background: none; /* Remove predefined background color (white) */
        transition: none; /* Disable predefined animations */
      }

      #workspaces button {
        color: #${colors.base05};
      }

      #workspaces button:hover {
        background-color: salmon;
        border: none;
      }

      /*
      #workspaces button.persistent {
        background-color: yellow;
      }
      */

      /* is visible on any monitor */
      #workspaces button.visible {
        background-color: #89dceb;
      }

      /* has focus */
      #workspaces button.active {
        background-color: #a6e3a1;
      }
    '';
    settings = {
      mainBar = {
        include = "~/.config/waybar/modules";
        id = "main-bar";
        name = "main-bar";
        layer = "top";
        position = "top";
        height = 32;
        passthrough = "false";
        width = 0;
        spacing = 6;
        margin = "0";
        margin-top = 0;
        margin-bottom = 0;
        margin-left = 0;
        margin-right = 0;
        ipc = true;

        modules-left = ["custom/menu" "hyprland/workspaces" "cpu" "memory" "disk"];
        modules-center = ["tray"];
        modules-right = ["pulseaudio" "network" "battery" "clock" "custom/power"];
      };
      # mainBar = {
      #   layer = "top";
      #   position = "top";
      #   height = 30;
      #   output = [
      #     "eDP-1"
      #     "HDMI-A-1"
      #   ];
      #   modules-left = ["sway/workspaces" "sway/mode" "wlr/taskbar"];
      #   modules-center = ["sway/window" "custom/hello-from-waybar"];
      #   modules-right = ["mpd" "custom/mymodule#with-css-id" "temperature"];
      #
      #   "sway/workspaces" = {
      #     disable-scroll = true;
      #     all-outputs = true;
      #   };
      #   "custom/hello-from-waybar" = {
      #     format = "hello {}";
      #     max-length = 40;
      #     interval = "once";
      #     exec = pkgs.writeShellScript "hello-from-waybar" ''
      #       echo "from within waybar"
      #     '';
      #   };
      # };
    };
  };
}