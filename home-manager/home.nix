{
  lib,
  inputs,
  config,
  pkgs,
  username,
  theme,
  font,
  hyprland,
  split-monitor-workspaces,
  ...
}: let
  inherit (config.colorScheme) colors;
  inherit (pkgs) fetchFromGitHub;
in {
  imports = [
    inputs.nix-colors.homeManagerModule
    inputs.nvim.inputs.nixvim.homeManagerModules.nixvim

    ./nvim
    ./config/waybar.nix
    ./config/lf.nix
    ./config/rofi.nix
  ];

  colorScheme = inputs.nix-colors.colorSchemes.${theme};

  home = {
    packages = with pkgs; [
      anki
      discord
      gucharmap
      gimp
      firefox
      keepassxc
      lxsession
      lazygit
      librewolf
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
    inherit username;
    homeDirectory = "/home/${username}";
  };

  programs = {
    home-manager.enable = true;
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;

        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };

        python.symbol = "󰌠 ";
        lua.symbol = "󰢱 ";
      };
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
    tmux = {
      enable = true;
      keyMode = "vi";
      mouse = true;
      newSession = true;
      prefix = "C-Space";
      terminal = "\${TERM}";
      escapeTime = 0;
      plugins = with pkgs.tmuxPlugins; [
        yank
        {
          plugin =
            mkTmuxPlugin
            {
              pluginName = "base16-tmux";
              version = "2023-10-19";
              rtpFilePath = "tmuxcolors.tmux";
              src = fetchFromGitHub {
                owner = "tinted-theming";
                repo = "base16-tmux";
                rev = "c02050bebb60dbb20cb433cd4d8ce668ecc11ba7";
                sha256 = "sha256-wDPg5elZPcQpu7Df0lI5O8Jv4A3T6jUQIVg63KDU+3Q=";
              };
            };
          extraConfig = ''
            set -g @colors-base16 "${theme}"
          '';
        }
      ];
      extraConfig = ''
        bind-key h select-pane -L
        bind-key j select-pane -D
        bind-key k select-pane -U
        bind-key l select-pane -R

        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      '';
    };
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      history.path = "${config.xdg.dataHome}/zsh/zsh_history";
      initExtra = ''
        myprompt() {
          if [[ -n $IN_NIX_SHELL ]]; then
            PS1="%{$fg[cyan]%}%~ %{$fg[red]%}(%{$fg[green]%}nix-shell%{$fg[red]%}) %{$fg[blue]%}--> "
            RPROMPT=
          fi
        }

        add-zsh-hook precmd myprompt
        BASE16_THEME_DEFAULT="${theme}"
        base16_${theme}
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
        {
          name = "base16-shell";
          file = "base16-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "tinted-theming";
            repo = "base16-shell";
            rev = "9706041539504a7dda5bf2411a0f513cce8460ad";
            sha256 = "sha256-k7acnFJKAU4lrfOEpsWDOtnMqP5sZfULa3vYTOix7DU=";
          };
        }
      ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.default;
    enableNvidiaPatches = true;
    systemd.enable = true;
    plugins = [
      split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
    extraConfig = builtins.readFile ./config/hypr/hyprland.conf;
  };

  gtk = {
    enable = true;
    cursorTheme = {
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
    package = pkgs.callPackage ./derivatives/touhou-cursors.nix {};
    name = "Reimu";
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
