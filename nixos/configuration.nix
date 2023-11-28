{
  inputs,
  lib,
  config,
  pkgs,
  hostname,
  timezone,
  locale,
  username,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  nixpkgs.overlays = [
    inputs.nixpkgs-f2k.overlays.window-managers
    inputs.nixpkgs-f2k.overlays.compositors
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    resumeDevice = "/dev/disk/by-partlabel/SWAP";
  };
  # boot.loader.grub.enable = true;
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking = {
    hostName = hostname;
    firewall.enable = false;
  };

  time.timeZone = timezone;

  fileSystems = {
    "/mnt/artix" = {
      device = "/dev/disk/by-label/ROOT";
      fsType = "btrfs";
    };
    "/mnt/hdd" = {
      device = "/dev/disk/by-label/HDD";
      fsType = "ext4";
    };
    "/mnt/hdd2" = {
      device = "/dev/disk/by-label/HDD2";
      fsType = "ext4";
    };
  };

  i18n = {
    defaultLocale = locale;
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
    };
  };

  console = {
    packages = with pkgs; [terminus_font];
    font = "ter-128b";
    useXkbConfig = true;
  };

  hardware = {
    opengl.enable = true;
    nvidia = {
      modesetting.enable = true;
      nvidiaPersistenced = true;
      powerManagement.enable = true;
    };
    opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    protectKernelImage = false;
    pam.services.swaylock.text = ''
      auth include login
    '';

    sudo.enable = false;
    doas.enable = true;
    doas.extraRules = [
      {
        users = ["kiipuri"];
        keepEnv = true;
        persist = true;
      }
    ];
  };

  services = {
    flatpak.enable = true;
    openssh.enable = true;
    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "de_se_fi";
      xkbOptions = "caps:escape";
      videoDrivers = ["nvidia"];
    };
    xserver.displayManager.sddm = {
      enable = true;
      theme = "tokyo-night-sddm";
    };

    xserver.windowManager = {
      awesome = {
        enable = true;
        package = pkgs.awesome-git;
      };
    };
    jellyfin.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  programs = {
    dconf.enable = true;
    hyprland = {
      enable = true;
      enableNvidiaPatches = true;
      xwayland.enable = true;
    };

    # waybar = {
    #   enable = true;
    #   package = inputs.waybar-git.packages.${pkgs.system}.default;
    # };

    noisetorch.enable = true;
    droidcam.enable = true;

    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      autosuggestions.enable = true;
      enableGlobalCompInit = true;
      enableCompletion = true;
      ohMyZsh = {
        enable = true;
        theme = "jonathan";
        plugins = [
          "vi-mode"
          "history-substring-search"
        ];
      };
      interactiveShellInit = ''
        zstyle ":completion:*" menu select
        zmodload zsh/complist
        bindkey -M menuselect 'h' vi-backward-char
        bindkey -M menuselect 'j' vi-down-line-or-history
        bindkey -M menuselect 'k' vi-up-line-or-history
        bindkey -M menuselect 'l' vi-forward-char

        bindkey -M vicmd 'k' history-substring-search-up
        bindkey -M vicmd 'j' history-substring-search-down

        lf() {
          set +m

          tmp="$(${pkgs.toybox}/bin/mktemp)"
          ${pkgs.lf}/bin/lf --last-dir-path="$tmp" "$@"
          if [ -f "$tmp" ]; then
            dir="$(${pkgs.toybox}/bin/cat "$tmp")"
            rm -f "$tmp"
            if [ -d "$dir" ]; then
              if [ "$dir" != "$(pwd)" ]; then
                cd "$dir" || exit
              fi
            fi
          fi
        }

        eval "$(zoxide init zsh)"
      '';

      promptInit = ''
        zle-line-init() {
          emulate -L zsh

          [[ $CONTEXT == start ]] || return 0

          while true; do
            zle .recursive-edit
            local -i ret=$?
            [[ $ret == 0 && $KEYS == $'\4' ]] || break
            [[ -o ignore_eof ]] || exit 0
          done

          local saved_prompt=$PROMPT
          local saved_rprompt=$RPROMPT
          PROMPT='> '
          RPROMPT='%'
          zle .reset-prompt
          PROMPT=$saved_prompt
          RPROMPT=$saved_rprompt

          if (( ret )); then
            zle .send-break
          else
            zle .accept-line
          fi
          return ret
        }

        zle -N zle-line-init
      '';

      shellAliases = {
        sudo = "doas";
        update = "sudo nixos-rebuild switch --flake .#nixos";
        hmupdate = "home-manager switch --flake .#kiipuri@nixos";
        ns = "NIXPKGS_ALLOW_UNFREE=1 nix-shell";
        nsp = "NIXPKGS_ALLOW_UNFREE=1 nix-shell -p";
      };
    };
  };

    steam.enable = true;
  };

  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs:
        with pkgs; [
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
        ];
    };
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerdfonts
      noto-fonts
      noto-fonts-cjk
      cascadia-code
      terminus_font
    ];
    fontconfig = {
      localConf = ''
        <match target="pattern">
          <test name="lang" compare="contains">
              <string>hi</string>
          </test>
          <test qual="any" name="family">
              <string>sans-serif</string>
          </test>
          <edit name="family" mode="prepend" binding="strong">
              <string>Noto Sans Devanagari</string>
          </edit>
        </match>
      '';
      defaultFonts = {
        serif = ["Noto Serif Devanagari" "Noto Serif"];
        sansSerif = ["Noto Sans"];
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      (libsForQt5.callPackage ../derivatives/tokyo-night-sddm.nix {})
      alsa-utils
      btop
      comma
      docker-compose
      dunst
      eza
      fd
      ffmpeg_6-full
      file
      git
      home-manager
      htop
      jellyfin-mpv-shim
      killall
      lf
      libnotify
      libsForQt5.fcitx5-qt
      libsForQt5.qt5.qtbase
      libsForQt5.qt5.qtgraphicaleffects
      libsForQt5.qt5.qtquickcontrols2
      libsForQt5.qt5.qtsvg
      lua5_4_compat
      neovim
      pavucontrol
      picom
      ripgrep
      swaybg
      sxhkd
      trash-cli
      unzip
      vim
      virt-manager
      wget
      wl-clipboard
      wlogout
      wofi
      xclip
    ];

    variables = {
      EDITOR = "nvim";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };

  users = {
    mutableUsers = false;
    users.root.hashedPassword = "$y$j9T$orXQD6ZLWsh8O8p0fyrsL1$eSwLvuV/xbCJC3Uq7pHw6SWS9pLC7vLOuqjeJzo1Nd3";
    users.${username} = {
      isNormalUser = true;
      shell = pkgs.zsh;
      hashedPassword = "$y$j9T$99Ie.QqXuV29Pgasvfpfa0$x4yJlYAvWERYxw3Vbbo8.xqHfvSUkzueJqOMUtpT9V1";
      extraGroups = ["wheel"];
    };
  };

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  virtualisation.libvirtd.enable = true;

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=5s
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
