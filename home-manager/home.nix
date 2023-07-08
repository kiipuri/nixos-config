# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  helpers,
  ...
}: {
  # You can import other home-manager modules here

  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    inputs.nix-colors.homeManagerModule
    inputs.mynvim.inputs.nixvim.homeManagerModules.nixvim

    # You can also split up your configuration and import pieces of it here:
    ./nvim
  ];

  home.packages = with pkgs; [
    (callPackage ./derivatives/screenshot.nix {})
    (callPackage ./derivatives/audiorec.nix {})
    (callPackage ./derivatives/rofi-shutdown.nix {})
    (callPackage ./derivatives/netuse.nix {})

    dconf
    gucharmap
    librewolf
    neofetch
    lazygit
  ];

  programs.nixvim.enable = true;
  # colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-hard;
  # colorScheme = inputs.nix-colors.colorSchemes.dracula;
  # colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-storm;
  colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-dark;
  # colorScheme = inputs.nix-colors.colorSchemes.harmonic16-dark;
  # colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };
  };

  home.pointerCursor = {
    x11.enable = true;
    x11.defaultCursor = "X_cursor";
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    gtk.enable = true;
  };

  programs.kitty = {
    enable = true;
    extraConfig = ''
      font_family JetBrainsMono Nerd Font
      font_size 16
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
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "kiipuri";
    homeDirectory = "/home/kiipuri";
  };

  xdg.configFile = {
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

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "kiipuri";
    userEmail = "kiipuri@proton.me";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  systemd.user.services.autorun = {
    Install.WantedBy = ["graphical-session.target"];
    Unit.PartOf = ["graphical-session.target"];
    Service = {
      ExecStart = "${pkgs.writeShellScript "autorun-start" ''
        ${pkgs.copyq}/bin/copyq &
        ${pkgs.iproute2}/bin/ifstat -t 1 -d 1 &
        ${pkgs.feh}/bin/feh --randomize --bg-scale /home/kiipuri/wallpapers --no-fehbg &
      ''}";
      ExecStop = "${pkgs.writeShellScript "autorun-stop" ''
        ${pkgs.copyq}/bin/copyq exit
        ${pkgs.procps}/bin/pkill ${pkgs.iproute2}/bin/ifstat
      ''}";
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
