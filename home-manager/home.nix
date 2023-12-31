{
  lib,
  inputs,
  pkgs,
  username,
  theme,
  font,
  hyprland,
  split-monitor-workspaces,
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
  ];

  colorScheme = inputs.nix-colors.colorSchemes.${theme};

  home = {
    packages = with pkgs; [
      anki
      discord
      ungoogled-chromium
      teams-for-linux
      gucharmap
      gimp
      firefox
      keepassxc
      lxsession
      lazygit
      librewolf
      neofetch
      nvtop
      pyprland
      qalculate-gtk
      slurp
      sonixd
      osu-lazer-bin
      transmission-gtk
      grim
      yt-dlp
      picard
      goldendict-ng
      tldr
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
        ${pkgs.coreutils}/bin/kill -SIGUSR1 $(${pkgs.toybox}/bin/pgrep kitty)
        ${pkgs.mako}/bin/makoctl reload
        ${pkgs.systemd}/bin/systemctl --user restart waybar.service
      '';
    };
  };

  programs = {
    home-manager.enable = true;
    fzf = {
      enable = true;
      enableZshIntegration = true;
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
    git = {
      enable = true;
      userName = "kiipuri";
      userEmail = "kiipuri@proton.me";
    };
    imv.enable = true;
    broot.enable = true;
    mpv = {
      enable = true;
      package = with pkgs; mpv-unwrapped.override {ffmpeg_5 = ffmpeg_6-full;};
    };
    bat.enable = true;
    nixvim.enable = true;
    zathura.enable = true;
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

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.default;
    systemd.enable = true;
    plugins = [
      split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
    extraConfig = builtins.readFile ./config/hypr/hyprland.conf;
  };

  gtk = {
    enable = true;
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
    ## You can add overlays here
    #overlays = [
    ## If you want to use overlays exported from other flakes:
    ## neovim-nightly-overlay.overlays.default
    #
    ## Or define it inline, for example:
    ## (final: prev: {
    ##   hi = final.hello.overrideAttrs (oldAttrs: {
    ##     patches = [ ./change-hello-to-hi.patch ];
    ##   });
    ## })
    #];
    ## Configure your nixpkgs instance

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
        "application/pdf" = "org.pwmt.zathura.desktop";
        "image/jpeg" = "imv.desktop";
        "image/png" = "imv.desktop";
        "image/webp" = "imv.desktop";
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
      pypr = {
        source = ./config/hypr/pyprland.toml;
        target = "hypr/pyprland.toml";
      };
    };
  };

  xdg.desktopEntries = {
    discord = {
      name = "Discord";
      genericName = "All-in-one cross-platform voice and text chat for gamers";
      exec = "discord --disable-gpu-sandbox";
      categories = ["Network" "InstantMessaging"];
      icon = "discord";
      mimeType = ["x-scheme-handler/discord"];
      type = "Application";
    };
  };

  services.easyeffects.enable = true;

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
        Unit.PartOf = ["graphical-session.target"];
        Service = {
          ExecStart = "${pkgs.writeShellScript "autorun-start" ''
            ${pkgs.swaybg}/bin/swaybg -i \
              $(cd ~/wallpapers && ${pkgs.coreutils}/bin/ls | \
              ${pkgs.coreutils}/bin/shuf | \
              ${pkgs.coreutils}/bin/head -n1 | \
              ${pkgs.findutils}/bin/xargs \
              ${pkgs.coreutils}/bin/realpath) -m stretch &
            ${pkgs.lxsession}/bin/lxpolkit &
          ''}";

          ExecStop = "${pkgs.writeShellScript "autorun-stop" ''
            ${pkgs.procps}/bin/pkill -f ${pkgs.swaybg}/bin/swaybg
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
