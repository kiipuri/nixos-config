{
  inputs,
  lib,
  config,
  pkgs,
  hostname,
  timezone,
  locale,
  username,
  secrets,
  pkgs-stable,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      rocmSupport = true;
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
      use-xdg-base-directories = false;
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

    initrd.kernelModules = ["amdgpu"];
    # initrd.systemd.enable = true;
  };

  # boot.loader.grub.enable = true;
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking = {
    hostName = hostname;
    firewall.checkReversePath = "loose";
    firewall.enable = false;
    networkmanager = {
      enable = true;
      insertNameservers = [secrets.dns-server "8.8.8.8"];
    };
  };

  time.timeZone = timezone;

  i18n = {
    defaultLocale = locale;
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        # fcitx5-mozc
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
    graphics.enable = true;
    amdgpu.opencl.enable = true;
    opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    protectKernelImage = false;

    sudo.enable = false;
    doas.enable = true;
    doas.extraRules = [
      {
        users = [username];
        keepEnv = true;
        persist = true;
      }
    ];
  };

  services = {
    # xserver.desktopManager.cinnamon.enable = true;
    rsyncd.enable = true;
    # headscale = {
    #   enable = true;
    #   address = "0.0.0.0";
    #   port = 5072;
    # };
    # tailscale.enable = true;
    spice-vdagentd.enable = true;
    ollama = {
      enable = true;
      acceleration = "rocm";
      rocmOverrideGfx = "11.0.0";
    };
    flatpak.enable = true;
    transmission = {
      enable = true;
      home = "/home/${username}";
      user = username;
      package = pkgs.transmission_4;
      settings = {
        download-dir = "/mnt/hdd/Torrents";
        incomplete-dir = config.services.transmission.settings.download-dir;
      };
    };
    openssh = {
      enable = true;
      ports = [79];
    };
    xserver = {
      enable = true;
      xkb = {
        variant = "de_se_fi";
        layout = "us";
        options = "caps:escape";
      };
      videoDrivers = ["amdgpu"];
      windowManager = {
        awesome = {
          enable = true;
          package = pkgs.awesome-git;
        };
      };
    };
    displayManager.sddm = {
      wayland.enable = true;
      enable = true;
      # theme = "tokyo-night-sddm";
      theme = "catppuccin-mocha";
      package = pkgs.kdePackages.sddm;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    gnome.gnome-keyring.enable = true;
  };

  programs = {
    adb.enable = true;
    dconf.enable = true;
    hyprland = {
      enable = true;
      package = pkgs-stable.hyprland;
    };
    appimage = {
      enable = true;
      binfmt = true;
    };
    gamemode.enable = true;
    droidcam.enable = true;
    virt-manager.enable = true;
    zsh.enable = true;
    command-not-found.enable = false;
    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
    steam.enable = true;
  };

  # nixpkgs.config.packageOverrides = pkgs: {
  #   steam = pkgs.steam.override {
  #     extraPkgs = pkgs:
  #       with pkgs; [
  #         xorg.libXcursor
  #         xorg.libXi
  #         xorg.libXinerama
  #         xorg.libXScrnSaver
  #         libpng
  #         libpulseaudio
  #         libvorbis
  #         stdenv.cc.cc.lib
  #         libkrb5
  #         keyutils
  #       ];
  #   };
  # };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      noto-fonts
      noto-fonts-cjk-sans
      terminus_font
    ];
    fontconfig = {
      defaultFonts = {
        serif = ["Noto Serif" "Noto Serif Devanagari" "Noto Naskh Arabic"];
        sansSerif = ["Noto Sans" "Noto Sans Devanagari" "Noto Sans Arabic"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      (libsForQt5.callPackage ../derivatives/tokyo-night-sddm.nix {})
      where-is-my-sddm-theme
      (catppuccin-sddm.override
        {
          flavor = "mocha";
        })
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
      killall
      lf
      libnotify
      # libsForQt5.fcitx5-qt
      # libsForQt5.qt5.qtbase
      # libsForQt5.qt5.qtgraphicaleffects
      # libsForQt5.qt5.qtquickcontrols2
      # libsForQt5.qt5.qtsvg
      lua5_4_compat
      neovim
      nh
      pavucontrol
      ripgrep
      swaybg
      sxhkd
      trash-cli
      unzip
      vim
      wget
      wl-clipboard
      wofi
      xclip
    ];

    variables = {
      EDITOR = "nvim";
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXPKGS_ALLOW_UNFREE = "1";
    };
  };

  users = {
    mutableUsers = false;
    users.root.hashedPassword = "$y$j9T$orXQD6ZLWsh8O8p0fyrsL1$eSwLvuV/xbCJC3Uq7pHw6SWS9pLC7vLOuqjeJzo1Nd3";
    users.${username} = {
      isNormalUser = true;
      shell = pkgs.zsh;
      hashedPassword = "$y$j9T$99Ie.QqXuV29Pgasvfpfa0$x4yJlYAvWERYxw3Vbbo8.xqHfvSUkzueJqOMUtpT9V1";
      extraGroups = ["wheel" "dialout" "adbusers" "kvm"];
    };
  };

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

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
