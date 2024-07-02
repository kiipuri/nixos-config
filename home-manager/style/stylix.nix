{
  config,
  lib,
  pkgs,
  themeName,
  font,
  fontPkg,
  cursor,
  cursorPkg,
  inputs,
  pkgs-eww,
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
                inherit font fontPkg pkgs config lib inputs;
                theme = inputs.nix-colors.colorSchemes.${mytheme};
              })
            (import ../window-managers/awesome/awesome.nix {
              inherit font config;
              theme = inputs.nix-colors.colorSchemes.${mytheme};
            })
            (import ../eww/eww.nix {
              inherit pkgs pkgs-eww;
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

      base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/${themeName}.yaml";
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
        qutebrowser.enable = true;
        fzf.enable = true;
        bat.enable = true;
        rofi.enable = true;
        vim.enable = true;
        zellij.enable = true;
      };
    };
  };
}
