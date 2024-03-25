{
  config,
  pkgs,
  font,
  theme,
  ...
}: let
  inherit (theme) colors;
in {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      * {
          border: none;
          border-radius: 0px;
          font-family: ${font};
          font-size: 18px;
      }

      window#waybar {
          background: transparent;
      }

      window#waybar.hidden {
          opacity: 0.2;
      }

      tooltip * {
          color: #${colors.base05};
          background-color: #${colors.base00};
      }

      #window {
          border-radius: 20px;
          transition: none;
          background: #${colors.base00};
          padding-left: 16px;
          padding-right: 16px;
          margin-left: 20px;
          margin-right: 20px;
      }

      .modules-left #workspaces {
          margin-right: 8px;
          border-radius: 20px;
          transition: none;
          background: #${colors.base00};
          border: none;
      }

      .modules-left #workspaces button {
          transition: none;
          color: #${colors.base05};
          background: transparent;
          padding: 5px 15px;
          border: none;
      }

      .modules-left #workspaces button.persistent {
          color: #${colors.base05};
          border: none;
      }

      .modules-left #workspaces button.active {
          border-radius: inherit;
          background: #${colors.base02};
          color: #${colors.base06};
          border: none;
      }

      /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
      #workspaces button:hover {
          transition: none;
          box-shadow: inherit;
          text-shadow: inherit;
          border-radius: inherit;
          color: #${colors.base05};
          background: #${colors.base01};
          border-bottom: 0px;
      }

      #workspaces button.focused {
          color: white;
          border: 0px;
          border-bottom: 0px;
      }

      #cpu {
          margin-left: 16px;
          padding-left: 16px;
          border-radius: 20px 0px 0px 20px;
          transition: none;
          color: #${colors.base0C};
          background: #${colors.base00};
      }

      #memory {
          padding-left: 16px;
          border-radius: 0px;
          transition: none;
          color: #${colors.base0C};
          background: #${colors.base00};
      }

      #disk {
          padding-left: 16px;
          padding-right: 16px;
          border-radius: 0px 20px 20px 0px;
          transition: none;
          color: #${colors.base0C};
          background: #${colors.base00};
      }

      #network {
          padding-left: 16px;
          color: #${colors.base0A};
          background-color: #${colors.base00};
      }

      #network.disconnected,
      #network.disabled {
        background-color: #${colors.base00};
        color: #cdd6f4;
      }
      #network.linked {
      }
      #network.ethernet {
      }
      #network.wifi {
      }

      #custom-date {
          padding-left: 16px;
          transition: none;
          color: #${colors.base0B};
          background: #${colors.base00};
      }

      #clock {
          padding-left: 16px;
          border-radius: 0px;
          transition: none;
          color: #${colors.base0C};
          background: #${colors.base00};
      }

      #custom-power {
          color: #${colors.base0D};
          background-color: #${colors.base00};
          padding-left: 16px;
          padding-right: 20px;
          border-radius: 0px 20px 20px 0px;
      }

      #custom-weather-icon {
          font-family: "Noto Color Emoji";
          padding-left: 16px;
          border-radius: 0px;
          transition: none;
          color: #${colors.base08};
          background: #${colors.base00};
      }

      #custom-weather {
          transition: none;
          color: #${colors.base08};
          background: #${colors.base00};
      }

      #pulseaudio {
          padding-left: 16px;
          transition: none;
          color: #${colors.base09};
          background: #${colors.base00};
      }

      #pulseaudio.muted {
          background-color: #${colors.base00};
          color: #${colors.base05};
      }

      #backlight {
          margin-right: 8px;
          padding-left: 16px;
          padding-right: 16px;
          border-radius: 10px;
          transition: none;
          color: #ffffff;
          background: #383c4a;
      }

      #battery {
          margin-right: 8px;
          padding-left: 16px;
          padding-right: 16px;
          border-radius: 10px;
          transition: none;
          color: #ffffff;
          background: #383c4a;
      }

      #battery.charging {
          color: #ffffff;
          background-color: #26A65B;
      }

      #battery.warning:not(.charging) {
          background-color: #ffbe61;
          color: black;
      }

      #battery.critical:not(.charging) {
          background-color: #f53c3c;
          color: #ffffff;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      #tray {
          padding-left: 16px;
          border-radius: 20px 0px 0px 20px;
          transition: none;
          color: #${colors.base05};
          background: #${colors.base00};
      }

      @keyframes blink {
          to {
              background-color: #ffffff;
              color: #000000;
          }
      }
    '';

    settings = {
      mainBar = {
        id = "main-bar";
        name = "main-bar";
        layer = "top";
        position = "top";
        passthrough = "false";
        width = 0;
        height = 40;
        spacing = 0;
        margin = "0";
        margin-top = 20;
        margin-bottom = 0;
        margin-left = 20;
        margin-right = 20;
        ipc = true;

        modules-left = ["custom/menu" "hyprland/workspaces" "cpu" "memory" "disk"];
        modules-center = ["hyprland/window"];
        modules-right = ["tray" "custom/weather-icon" "custom/weather" "pulseaudio" "network" "battery" "custom/date" "clock" "custom/power"];

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

        tray = {
          icon-size = 24;
          spacing = 4;
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

        "custom/weather-icon" = {
          format = "{}";
          interval = 1800;
          exec = pkgs.writeShellScript "waybar-weather-icon" ''
            ${pkgs.curl}/bin/curl -s "wttr.in/$(${pkgs.coreutils}/bin/cat ${config.sops.secrets.city.path})?format=%c" | ${pkgs.toybox}/bin/sed 's/\s*//g'
          '';
        };

        "custom/weather" = {
          format = " {}";
          interval = 1800;
          exec = pkgs.writeShellScript "waybar-weather" ''
            ${pkgs.curl}/bin/curl -s "wttr.in/$(${pkgs.coreutils}/bin/cat ${config.sops.secrets.city.path})?format=%t" | ${pkgs.toybox}/bin/sed 's/\s*//g'
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
