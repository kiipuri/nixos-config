{
  config,
  lib,
  pkgs,
  theme,
  font,
  fontPkg,
  cursor,
  cursorPkg,
  inputs,
  ...
}: let
  themes = [
    "catppuccin-mocha"
    "gruvbox-light-hard"
    "rose-pine-moon"
    "sakura"
  ];

  themeSpecialisations = builtins.listToAttrs (map (mytheme: {
      name = mytheme;
      value = {
        configuration = {
          stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${mytheme}.yaml";
          imports = [
            (import ../config/waybar.nix
              {
                inherit font fontPkg pkgs config lib;
                theme = inputs.nix-colors.colorSchemes.${mytheme};
              })
            (import ../nvim
              {
                inherit font fontPkg pkgs config lib;
                theme = inputs.nix-colors.colorSchemes.${mytheme};
              })
          ];
        };
      };
    })
    themes);
in {
  config = {
    specialisation = themeSpecialisations;
    stylix = {
      autoEnable = false;
      image = pkgs.fetchurl {
        url = "https://img3.gelbooru.com//samples/03/d1/sample_03d1a90180adbbade6111f7ec43b7d6b.jpg";
        sha256 = "sha256-dP/+FGhjKOavj66/uWPidkWMvMhqh4UJLPj5zysEkJY=";
      };

      base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/${theme}.yaml";
      fonts = {
        monospace = {
          package = fontPkg;
          name = font;
        };
        sansSerif = {
          package = fontPkg;
          name = font;
        };
        serif = {
          package = fontPkg;
          name = font;
        };
        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
        sizes.popups = 14;
      };
      cursor = {
        package = cursorPkg;
        name = cursor;
      };
      targets = {
        kitty.enable = true;
        mako.enable = true;
        gtk.enable = true;
        zathura.enable = true;
        tmux.enable = true;
        qutebrowser.enable = true;
        fzf.enable = true;
        bat.enable = true;
        rofi.enable = true;
        vim.enable = true;
        zellij.enable = true;
        # waybar = {
        #   enable = true;
        #   enableLeftBackColors = true;
        #   enableCenterBackColors = true;
        #   enableRightBackColors = true;
        # };
      };
    };
  };
}
