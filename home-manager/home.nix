{
  inputs,
  config,
  pkgs,
  ...
}: let
  theme = config.colorScheme;
  inherit (theme) colors;
in {
  imports = [
    inputs.nix-colors.homeManagerModule
    inputs.mynvim.inputs.nixvim.homeManagerModules.nixvim

    ./nvim
    ./config/waybar.nix
    ./config/lf.nix
  ];

  home = {
    packages = with pkgs; [
      #(callPackage ./derivatives/screenshot.nix {})
      #(callPackage ./derivatives/audiorec.nix {})
      #(callPackage ./derivatives/rofi-shutdown.nix {})
      #(callPackage ./derivatives/netuse.nix {})

      (builtins.getFlake "github:sopa0/hyprsome/9636be05ef20fbe473709cc3913b5bbf735eb4f3").packages.${system}.default
      anki
      dconf
      discord
      gucharmap
      gimp
      firefox
      keepassxc
      lxsession
      lazygit
      librewolf
      mpv
      neofetch
      nvtop
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
    ];
    username = "kiipuri";
    homeDirectory = "/home/kiipuri";
  };

  programs = {
    bat.enable = true;
    nixvim.enable = true;
    zathura.enable = true;
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh = {
      enable = true;
      initExtra = ''
        myprompt() {
          if [[ -n $IN_NIX_SHELL ]]; then
            PS1="%{$fg[cyan]%}%~ %{$fg[red]%}(%{$fg[green]%}nix-shell%{$fg[red]%}) %{$fg[blue]%}--> "
            RPROMPT=
          fi
        }

        add-zsh-hook precmd myprompt
      '';
      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.7.0";
            sha256 = "sha256-oQpYKBt0gmOSBgay2HgbXiDoZo5FoUKwyHSlUrOAP5E=";
          };
        }
        {
          name = "zsh-vi-mode";
          src = pkgs.fetchFromGitHub {
            owner = "jeffreytse";
            repo = "zsh-vi-mode";
            rev = "v0.10.0";
            sha256 = "sha256-QE6ZwwM2X0aPqNnbVrj0y7w9hmuRf0H1j8nXYwyoLo4=";
          };
        }
      ];
    };
  };
  colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-dark;
  # colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-hard;
  # colorScheme = inputs.nix-colors.colorSchemes.gruvbox-light-hard;
  # colorScheme = inputs.nix-colors.colorSchemes.dracula;
  # colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-storm;
  # colorScheme = inputs.nix-colors.colorSchemes.harmonic16-dark;
  # colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    systemdIntegration = true;
    recommendedEnvironment = true;
    plugins = [
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
    extraConfig = builtins.readFile ./config/hypr/hyprland.conf;
  };

  gtk = {
    enable = true;
    cursorTheme = {
      # package = pkgs.bibata-cursors;
      # name = "Bibata-Modern-Ice";
      package = pkgs.callPackage ./derivatives/touhou-cursors.nix {};
      name = "Reimu";
    };
    theme = {
      package = pkgs.tokyo-night-gtk;
      name = "Tokyonight-Storm-B";
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };

  home.pointerCursor = {
    x11.enable = true;
    x11.defaultCursor = "X_cursor";
    # package = pkgs.bibata-cursors;
    # name = "Bibata-Original-Amber";

    package = pkgs.callPackage ./derivatives/touhou-cursors.nix {};
    name = "Reimu";
    gtk.enable = true;
  };

  programs.kitty = {
    enable = true;
    extraConfig = ''
      font_family JetBrainsMono Nerd Font
      font_size 16
      map f1 launch --cwd=current --type=background kitty
    '';
    settings = {
      foreground = "#${config.colorScheme.colors.base05}";
      background = "#${config.colorScheme.colors.base00}";
      window_padding_width = 10;
      font_family = "Cascadia Code";
      font_size = 18;
      confirm_os_window_close = 0;
      enable_audio_bell = "no";
    };
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
    configFile = {
      lf = {
        source = ./config/lf;
        recursive = true;
      };
      awesome = {
        source = ./config/awesome;
        recursive = true;
      };
      rofi = {
        source = ./config/rofi;
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

    goldendict-ng = {
      name = "GoldenDict-NG works";
      genericName = "Multiformat Dictionary";
      comment = "A feature-rich dictionary lookup program";
      exec = "/run/current-system/sw/bin/env QT_PLUGIN_PATH=\"\\$QT_PLUGIN_PATH:${pkgs.fcitx5-with-addons}/lib/qt-6/plugins\" QT_IM_MODULE=fcitx goldendict %u";
      categories = ["Office" "Dictionary" "Education" "Qt"];
      icon = "goldendict";
      mimeType = ["x-scheme-handler/goldendict" "x-scheme-handler/dict"];
      type = "Application";
      terminal = false;
    };
  };

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "kiipuri";
    userEmail = "kiipuri@proton.me";
  };

  services.mako = {
    enable = true;
    anchor = "top-right";
    backgroundColor = "#${colors.base00}";
    textColor = "#${colors.base05}";
    borderColor = "#${colors.base05}";
    borderRadius = 10;
    borderSize = 5;
    padding = "10";
    font = "JetBrainsMono Nerd Font Regular 18";
    height = 200;
    width = 500;
    defaultTimeout = 5000;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  systemd.user.services.autorun = {
    Install.WantedBy = ["graphical-session.target"];
    Unit.PartOf = ["graphical-session.target"];
    Service = {
      ExecStart = "${pkgs.writeShellScript "autorun-start" ''
        ${pkgs.swaybg}/bin/swaybg -i $(cd ~/wallpapers && ${pkgs.coreutils}/bin/ls | ${pkgs.coreutils}/bin/shuf | ${pkgs.coreutils}/bin/head -n1 | ${pkgs.findutils}/bin/xargs ${pkgs.coreutils}/bin/realpath) -m stretch &
        ${pkgs.lxsession}/bin/lxpolkit &
      ''}";

      ExecStop = "${pkgs.writeShellScript "autorun-stop" ''
        ${pkgs.procps}/bin/pkill -f ${pkgs.swaybg}/bin/swaybg
        ${pkgs.procps}/bin/pkill -f ${pkgs.lxsession}/bin/lxpolkit
      ''}";

      Type = "forking";
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
