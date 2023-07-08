# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
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
    (builtins.getFlake "github:fortuneteller2k/nixpkgs-f2k/9773e93c3b81d645aabb95b8635a8c512e17aa3b").overlays.default
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  networking.firewall.enable = false;
  #config.networking.nftables.enable = false;

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    # font = "Lat2-Terminus16";
    font = "${pkgs.terminus_font}/share/consolefonts/ter-732b.psf.gz";
    # keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  services.openssh.enable = true;

  services.xserver.enable = true;
  services.xserver = {
    layout = "us";
    xkbVariant = "de_se_fi";
    xkbOptions = "caps:escape";
  };

  services.xserver.displayManager = {
    lightdm.enable = true;
    startx.enable = true;
    setupCommands = "${pkgs.xorg.xrandr}/bin/xrandr --output Virtual-1 --primary --mode 1920x1080";
  };
  services.xserver.windowManager = {
    awesome.enable = true;
    awesome.package = pkgs.awesome-git;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     tree
  #   ];
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (builtins.getFlake "github:fortuneteller2k/nixpkgs-f2k/9773e93c3b81d645aabb95b8635a8c512e17aa3b").packages.${system}.awesome-git
    dunst
    fd
    ffmpeg
    file
    git
    inputs.agenix.packages.${system}.default
    killall
    lf
    libnotify
    lua5_4_compat
    ripgrep
    rofi
    sxhkd
    trash-cli
    unzip
    vim
    wget
    xclip
  ];

  fonts.fonts = with pkgs; [
    nerdfonts
    noto-fonts
    noto-fonts-cjk
    cascadia-code
    terminus_font
  ];

  environment.variables.EDITOR = "nvim";

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
    enableGlobalCompInit = true;
    enableCompletion = true;
    ohMyZsh.enable = true;
    ohMyZsh.theme = "jonathan";
    ohMyZsh.plugins = ["vi-mode"];
    interactiveShellInit = ''
      zstyle ":completion:*" menu select
      zmodload zsh/complist
      bindkey -M menuselect 'h' vi-backward-char
      bindkey -M menuselect 'j' vi-down-line-or-history
      bindkey -M menuselect 'k' vi-up-line-or-history
      bindkey -M menuselect 'l' vi-forward-char

      source "$HOME/.config/lf/lfcd"
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
    };
  };

  users.mutableUsers = false;
  users.users.root.password = "pass";
  users.users.kiipuri = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel"];
    passwordFile = config.age.secrets.password.path;
    # passwordFile = "/home/kiipuri/password.txt";
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

  services.libreddit = {
    enable = true;
    port = 10001;
    address = "127.0.0.1";
  };

  age.secrets.password.file = ../secrets/password.age;
  age.secrets.searxng.file = ../secrets/searxng.age;
  age.secrets.id_ed25519 = {
    file = ../secrets/id_ed25519.age;
    path = "/home/kiipuri/.ssh/";
    owner = "kiipuri";
    group = "users";
  };

  services.searx = {
    enable = true;
    package = pkgs.searxng;
    environmentFile = /. + config.age.secrets.searxng.path;
    settings = {
      server.port = 10000;
      server.bind_address = "127.0.0.1";
      server.secret_key = "@SEARX_SECRET_KEY@";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
