{
  inputs,
  lib,
  config,
  pkgs,
  stable,
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
    hostName = "nixos";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  time.timeZone = "Europe/Helsinki";

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

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

  console = {
    packages = with pkgs; [terminus_font];
    font = "ter-128b";
    useXkbConfig = true;
  };

  services = {
    openssh.enable = true;

    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "de_se_fi";
      xkbOptions = "caps:escape";
      videoDrivers = ["nvidia"];
    };

    # xserver.displayManager = {
    #   lightdm.enable = true;
    #   startx.enable = true;
    #   setupCommands = "${pkgs.xorg.xrandr}/bin/xrandr --output Virtual-1 --primary --mode 1920x1080";
    # };

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

  programs = {
    hyprland = {
      enable = true;
      enableNvidiaPatches = true;
      xwayland.enable = false;
    };

    # waybar = {
    #   enable = true;
    #   package = inputs.waybar-git.packages.${pkgs.system}.default;
    # };

    noisetorch.enable = true;
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    protectKernelImage = false;
    pam.services.swaylock.text = ''
      auth include login
    '';
  };

  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
  };

  # services.pipewire = {
  #   enable = true;
  #   package = stable.pipewire;
  #   alsa.enable = true;
  #   alsa.support32Bit = true;
  #   pulse.enable = true;
  # };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.gamescope.enable = true;

  environment = {
    sessionVariables = {
      GDK_BACKEND = "wayland,x11";
      QT_QPA_PLATFORM = "wayland;xcb";
      #SDL_VIDEODRIVER = "x11";
      CLUTTER_BACKEND = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    systemPackages = with pkgs; [
      (builtins.getFlake "github:fortuneteller2k/nixpkgs-f2k/9773e93c3b81d645aabb95b8635a8c512e17aa3b").packages.${system}.awesome-git
      (libsForQt5.callPackage ../derivatives/tokyo-night-sddm.nix {})
      alsa-utils
      dunst
      fd
      ffmpeg
      file
      docker-compose
      git
      home-manager
      htop
      killall
      lf
      libnotify
      libsForQt5.qt5.qtbase
      libsForQt5.qt5.qtgraphicaleffects
      libsForQt5.qt5.qtquickcontrols2
      libsForQt5.qt5.qtsvg
      libsForQt5.fcitx5-qt
      lua5_4_compat
      neovim
      jellyfin-mpv-shim
      pavucontrol
      ripgrep
      rofi
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

  fonts.packages = with pkgs; [
    nerdfonts
    noto-fonts
    noto-fonts-cjk
    cascadia-code
    terminus_font
  ];

  environment.variables = {
    EDITOR = "nvim";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
    enableGlobalCompInit = true;
    enableCompletion = true;
    ohMyZsh = {
      enable = true;
      theme = "jonathan";
      plugins = ["vi-mode" "history-substring-search"];
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

      source "$HOME/.config/lf/lfcd"
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

  users = {
    mutableUsers = false;
    users.root.hashedPassword = "$y$j9T$orXQD6ZLWsh8O8p0fyrsL1$eSwLvuV/xbCJC3Uq7pHw6SWS9pLC7vLOuqjeJzo1Nd3";
    users.kiipuri = {
      isNormalUser = true;
      shell = pkgs.zsh;
      hashedPassword = "$y$j9T$99Ie.QqXuV29Pgasvfpfa0$x4yJlYAvWERYxw3Vbbo8.xqHfvSUkzueJqOMUtpT9V1";
      extraGroups = ["wheel"];
    };
  };

  security.sudo.enable = false;
  security.doas.enable = true;
  security.doas.extraRules = [
    {
      users = ["kiipuri"];
      keepEnv = true;
      persist = true;
    }
  ];

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
