{
  config,
  lib,
  inputs,
  pkgs,
  username,
  themeName,
  font,
  ...
}: {
  imports = [
    inputs.nix-colors.homeManagerModule
    inputs.nvim.inputs.nixvim.homeManagerModules.nixvim

    ./config/lf.nix
    ./config/rofi.nix
    ./style/stylix.nix
    ./shell/shell.nix
    ./browser/qutebrowser.nix
    ./mpv/mpv.nix
    ./window-managers/hyprland/hyprland.nix
    ./easyeffects/default.nix
  ];

  colorScheme = inputs.nix-colors.colorSchemes.${themeName};

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    defaultSymlinkPath = "/run/user/1000/secrets";
    secrets = {
      city = {};
    };
  };

  home = {
    packages = with pkgs; [
      anki
      vesktop
      ungoogled-chromium
      teams-for-linux
      rofi-rbw-wayland
      gucharmap
      gimp
      firefox
      keepassxc
      lxsession
      lazygit
      librewolf
      neofetch
      nvtopPackages.nvidia
      pyprland
      qalculate-gtk
      slurp
      sonixd
      osu-lazer-bin
      onlyoffice-bin
      transmission-remote-gtk
      grim
      yt-dlp
      picard
      goldendict-ng
      jq
    ];
    inherit username;
    homeDirectory = "/home/${username}";
    activation = {
      reloadConfigs = lib.hm.dag.entryAfter ["writeBoundary"] ''
        for socket in $(${pkgs.fd}/bin/fd --type=socket nvim /run/user/1000); do
          for file in $(${pkgs.fd}/bin/fd --extension=lua . ~/.config/nvim | sort --reverse); do
            ${pkgs.neovim-remote}/bin/nvr --servername $socket -c "so $file"
          done
        done

        ${pkgs.coreutils}/bin/kill -SIGUSR1 $(${pkgs.toybox}/bin/pgrep kitty) 2>/dev/null
        ${pkgs.coreutils}/bin/kill -SIGUSR1 $(${pkgs.toybox}/bin/pgrep picom) 2>/dev/null
        ${pkgs.coreutils}/bin/kill -SIGUSR2 $(${pkgs.toybox}/bin/pgrep waybar) 2>/dev/null
        ${pkgs.mako}/bin/makoctl reload 2>/dev/null
        ${pkgs.systemd}/bin/systemctl --user start sops-nix.service
      '';
    };
    sessionVariables = {
      MEDNAFEN_HOME = "${config.xdg.configHome}/mednafen";
      XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompose";
      DOCKER_CONFIG = "${config.xdg.configHome}/docker";
      CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";
      NIXOS_OZONE_WL = 1;
    };
  };

  programs = {
    home-manager.enable = true;
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    wlogout = {
      enable = true;
      layout = [
        {
          label = "lock";
          action = "swaylock";
          text = "Lock";
          keybind = "l";
        }
        {
          label = "hibernate";
          action = "${pkgs.systemd}/bin/systemctl hibernate";
          text = "Hibernate";
          keybind = "h";
        }
        {
          label = "logout";
          action = "${pkgs.systemd}/bin/loginctl kill-session $XDG_SESSION_ID";
          text = "Logout";
          keybind = "e";
        }
        {
          label = "shutdown";
          action = "${pkgs.systemd}/bin/systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
        }
        {
          label = "suspend";
          action = "${pkgs.systemd}/bin/systemctl suspend";
          text = "Suspend";
          keybind = "u";
        }
        {
          label = "reboot";
          action = "${pkgs.systemd}/bin/systemctl reboot";
          text = "Reboot";
          keybind = "r";
        }
      ];
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        python.symbol = "󰌠 ";
        lua.symbol = "󰢱 ";
      };
    };
    zellij.enable = true;
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    tealdeer = {
      enable = true;
      settings = {
        updates.auto_update = true;
      };
    };
    git = {
      enable = true;
      userName = "kiipuri";
      userEmail = "kiipuri@proton.me";
    };
    imv.enable = true;
    broot.enable = true;
    bat.enable = true;
    nixvim.enable = true;
    zathura = {
      enable = true;
      options = {
        selection_clipboard = "clipboard";
      };
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    kitty = {
      enable = true;
      extraConfig = ''
        map f1 launch --cwd=current --type=background kitty
        # term xterm-256color
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
  };

  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
  };

  qt = {
    enable = true;
    platformTheme = "gtk3";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };

  home.pointerCursor = {
    x11.enable = true;
    x11.defaultCursor = "X_cursor";
    gtk.enable = true;
  };

  nixpkgs = {
    overlays = [
      (import ./overlays/btop.nix)
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/ogg" = "mpv.desktop";
        "application/pdf" = "org.pwmt.zathura.desktop";
        "audio/mpeg" = "mpv.desktop";
        "audio/ogg" = "mpv.desktop";
        "audio/mp4" = "mpv.desktop";
        "audio/vnd.wave" = "mpv.desktop";
        "audio/webm" = "mpv.desktop";
        "audio/x-aac" = "mpv.desktop";
        "audio/x-wav" = "mpv.desktop";
        "image/jpeg" = "imv.desktop";
        "image/png" = "imv.desktop";
        "image/webp" = "imv.desktop";
        "video/ogg" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "video/mp4" = "mpv.desktop";
      };
    };
    configFile = {
      awesome = {
        source = ./config/awesome;
        recursive = true;
      };
      picom = {
        source = ./config/picom;
        recursive = true;
      };
      dunst = {
        source = ./config/dunst;
        recursive = true;
      };
    };
  };

  services.mako = {
    enable = true;
    anchor = "top-right";
    borderRadius = 10;
    borderSize = 5;
    padding = "10";
    font = lib.mkForce "${font} Regular 18";
    height = 200;
    width = 500;
    defaultTimeout = 5000;
  };

  systemd = {
    user = {
      # Nicely reload system units when changing configs
      startServices = "sd-switch";

      services.autorun = {
        Install.WantedBy = ["graphical-session.target"];
        Unit = {
          PartOf = ["graphical-session.target"];
          After = ["graphical-session.target"];
        };
        Service = {
          ExecStart = "${pkgs.writeShellScript "autorun-start" ''
            wallpaper=$(cd ~/wallpapers && ${pkgs.coreutils}/bin/ls | \
              ${pkgs.coreutils}/bin/shuf | \
              ${pkgs.coreutils}/bin/head -n1 | \
              ${pkgs.findutils}/bin/xargs \
              ${pkgs.coreutils}/bin/realpath)

            environ=$(${pkgs.busybox}/bin/strings /proc/$(echo $$)/environ)

            if [[ $environ == *"WAYLAND_DISPLAY"* ]]; then
              ${pkgs.swaybg}/bin/swaybg -i $wallpaper -m fill &
            elif [[ $environ == *"DISPLAY"* ]]; then
              ${pkgs.feh}/bin/feh --no-fehbg --bg-fill $wallpaper &
            fi

            ${pkgs.lxsession}/bin/lxpolkit &
          ''}";

          ExecStop = "${pkgs.writeShellScript "autorun-stop" ''
            ${pkgs.procps}/bin/pkill -f ${pkgs.swaybg}/bin/swaybg
            ${pkgs.procps}/bin/pkill -f ${pkgs.feh}/bin/feh
            ${pkgs.procps}/bin/pkill -f ${pkgs.fcitx5}/bin/fcitx5
            ${pkgs.procps}/bin/pkill -f ${pkgs.lxsession}/bin/lxpolkit
          ''}";

          Type = "forking";
        };
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
