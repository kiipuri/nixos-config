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
    systemd.enable = true;
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

      #custom-date {
        background-color: #fdffb6;
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
      /*
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
      */

      #custom-weather {
        background-color: #cba6f7;
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
      #custom-weather,
      #custom-date,
      #custom-power,
      #network {
        border-radius: 4px;
        margin: 6px 0px;
        padding: 2px 8px;
        color: #${colors.base00};
      }

      #custom-power {
        background-color: #f38ba8;
        margin-right: 4px;
        padding: 0 10px 0 8px;
        font-size: 16px;
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
        color: #${colors.base00};
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
        color: #${colors.base00};
      }
    '';
    settings = {
      mainBar = {
        # include = "~/.config/waybar/modules";
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
        modules-right = ["custom/weather" "pulseaudio" "network" "battery" "custom/date" "clock" "custom/power"];

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "11" = "1";
            "12" = "2";
            "13" = "3";
            "14" = "4";
            "15" = "5";
            "16" = "6";
            "17" = "7";
            "18" = "8";
            "19" = "9";
          };
        };

        clock = {
          interval = 60;
          align = 0;
          rotate = 0;
          tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
          format = " {:%H:%M}";
          # format-alt = " {:%a %b %d, %G}";
        };

        "custom/date" = {
          interval = 60;
          format = " {}";
          exec = "${pkgs.toybox}/bin/date +\"%a %d %b %G\"";
        };

        cpu = {
          interval = 5;
          format = "󰄧 LOAD: {usage}%";
        };

        "custom/power" = {
          format = "󰐥";
          tooltip = false;
          on-click = "${pkgs.wlogout}/bin/wlogout";
        };

        disk = {
          interval = 30;
          format = "󰆼 FREE: {free}";
        };

        memory = {
          interval = 10;
          format = " USED: {used:0.1f}G";
        };

        network = {
          interval = 1;
          # //interface = "wlan*";
          format-wifi = " {essid}";
          format-ethernet = "󰈀 {ipaddr}/{cidr}";
          format-linked = "󰈀 {ifname} (No IP)";
          format-disconnected = "󰖪 Disconnected";
          format-disabled = "󰖪 Disabled";
          format-alt = " {bandwidthDownBits} |  {bandwidthUpBits}";
          # //format-alt = " {bandwidthDownBits} |  {bandwidthUpBits}";
          tooltip-format = " {ifname} via {gwaddr}";
        };

        "custom/weather" = {
          format = "{}";
          interval = 1800;
          exec = pkgs.writeShellScript "waybar-weather" ''
            ${pkgs.curl}/bin/curl -s 'wttr.in/Tornio?format=%c%t' | ${pkgs.toybox}/bin/sed 's/+//; s/  / /'
          '';
        };

        pulseaudio = {
          # format = "{volume}% {icon} {format_source}";
          format = "{icon} {volume}%";
          format-muted = " Mute";
          format-bluetooth = " {volume}% {format_source}";
          format-bluetooth-muted = " Mute";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          scroll-step = 5.0;
          on-click = "${pkgs.alsa-utils}/bin/amixer set Master toggle";
          on-click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
          smooth-scrolling-threshold = 1;
        };
      };
    };
  };
}
