{
  config,
  lib,
  inputs,
  pkgs,
  username,
  themeName,
  font,
  ...
}: let
  touhou-cursors = pkgs.callPackage ./derivatives/touhou-cursors.nix {};
in {
  imports = [
    inputs.nix-colors.homeManagerModule
    inputs.nvim.inputs.nixvim.homeManagerModules.nixvim

    ./config/rofi.nix
    ./style/stylix.nix
    ./shell/default.nix
    ./browser/qutebrowser.nix
    ./bitwarden/rbw.nix
    ./mpv/mpv.nix
    ./window-managers/hyprland/hyprland.nix
    ./easyeffects/default.nix
    ./tex/texlive.nix
    ./yazi/yazi.nix
  ];

  colorScheme = inputs.nix-colors.colorSchemes.${themeName};

  home = {
    file.".local" = {
      source = touhou-cursors;
      recursive = true;
    };
    enableNixpkgsReleaseCheck = false;
    packages = with pkgs; [
      (pkgs.symlinkJoin
        {
          name = "feishin";
          paths = [pkgs.feishin];
          buildInputs = [pkgs.makeWrapper];
          postBuild = ''
            wrapProgram $out/bin/feishin \
              --add-flags "--password-store='gnome-libsecret' --enable-wayland-ime"
          '';
        })
      just
      anki-bin
      btop
      webcord-vencord
      vesktop
      orca-slicer
      freecad
      freetube
      ungoogled-chromium
      rofi-rbw-wayland
      gucharmap
      gimp
      arduino-ide
      firefox
      lazygit
      librewolf
      neofetch
      magic-wormhole
      qalculate-gtk
      slurp
      osu-lazer-bin
      transmission-remote-gtk
      grim
      yt-dlp
      picard
      goldendict-ng
      jq
      nix-output-monitor
    ];
    inherit username;
    homeDirectory = "/home/${username}";
    activation = {
      reloadConfigs = lib.hm.dag.entryAfter ["writeBoundary"] ''
        for socket in $(${pkgs.fd}/bin/fd --type=socket nvim /run/user/1000); do
          for file in $(${pkgs.fd}/bin/fd --extension=lua . ~/.config/nvim | sort --reverse); do
            run --silence ${pkgs.neovim-remote}/bin/nvr --servername $socket -c "so $file"
          done
        done

        run --silence ${pkgs.coreutils}/bin/kill -SIGUSR1 $(${pkgs.toybox}/bin/pgrep kitty)
        run --silence ${pkgs.coreutils}/bin/kill -SIGUSR1 $(${pkgs.toybox}/bin/pgrep picom)
        run --silence ${pkgs.coreutils}/bin/kill -SIGUSR2 $(${pkgs.toybox}/bin/pgrep waybar)
        run --silence ${pkgs.mako}/bin/makoctl reload
        run --silence ${pkgs.systemd}/bin/systemctl --user start sops-nix.service

        # hack to fix awesome.restart()
        PATH+=":${pkgs.dbus}/bin"
        run --silence ${pkgs.awesome}/bin/awesome-client "awesome.restart()"
      '';
    };
    sessionVariables = {
      MEDNAFEN_HOME = "${config.xdg.configHome}/mednafen";
      XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompose";
      DOCKER_CONFIG = "${config.xdg.configHome}/docker";
      CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";
      NIXOS_OZONE_WL = 1;
      GTK_IM_MODULE = "";
    };
  };

  programs = {
    home-manager.enable = true;
    fzf = {
      enable = true;
      enableZshIntegration = true;
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
      extraConfig.safe.directory = "*";
    };
    imv.enable = true; # image viewer
    broot.enable = true;
    bat.enable = true;
    nixvim.enable = true;
    zathura = {
      enable = true;
      options = {
        selection-clipboard = "clipboard";
      };
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    mangohud.enable = true;
  };

  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };

  home.pointerCursor = {
    x11.enable = true;
    x11.defaultCursor = "X_cursor";
    gtk.enable = true;
  };

  nixpkgs = {
    overlays = [];
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

        "default-web-browser" = "org.qutebrowser.qutebrowser.desktop";
        "text/html" = "org.qutebrowser.qutebrowser.desktop";
        "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
        "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
        "x-scheme-handler/about" = "org.qutebrowser.qutebrowser.desktop";
        "x-scheme-handler/unknown" = "org.qutebrowser.qutebrowser.desktop";
      };
    };
    # configFile = {
    #   picom = {
    #     source = ./config/picom;
    #     recursive = true;
    #   };
    #   dunst = {
    #     source = ./config/dunst;
    #     recursive = true;
    #   };
    # };
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
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
