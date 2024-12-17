{
  pkgs,
  theme,
  ...
}: let
  inherit (theme) palette;
  colors = ''
    $base-color: #${palette.base00};
    $base-color-variant: #${palette.base02};
    $border: 4px solid #${palette.base0D};
    $font-color: #${palette.base05};

    $base06: #${palette.base06};
    $base07: #${palette.base07};
    $base08: #${palette.base08};
    $base09: #${palette.base09};
    $base0A: #${palette.base0A};
    $base0B: #${palette.base0B};
    $base0C: #${palette.base0C};
    $base0D: #${palette.base0D};
    $base0E: #${palette.base0E};
    $base0F: #${palette.base0F};

    .base06 {
      color: #${palette.base06};
      .meter scale trough highlight { background-color: #${palette.base06}; }
    }
    .base07 {
      color: #${palette.base07};
      .meter scale trough highlight { background-color: #${palette.base07}; }
    }
    .base08 {
      color: #${palette.base08};
      .meter scale trough highlight { background-color: #${palette.base08}; }
    }
    .base09 {
      color: #${palette.base09};
      .meter scale trough highlight { background-color: #${palette.base09}; }
    }
    .base0A {
      color: #${palette.base0A};
      .meter scale trough highlight { background-color: #${palette.base0A}; }
    }
    .base0B {
      color: #${palette.base0B};
      .meter scale trough highlight { background-color: #${palette.base0B}; }
    }
    .base0C {
      color: #${palette.base0C};
      .meter scale trough highlight { background-color: #${palette.base0C}; }
    }
    .base0D {
      color: #${palette.base0D};
      .meter scale trough highlight { background-color: #${palette.base0D}; }
    }
    .base0E {
      color: #${palette.base0E};
      .meter scale trough highlight { background-color: #${palette.base0E}; }
    }
    .base0F {
      color: #${palette.base0F};
      .meter scale trough highlight { background-color: #${palette.base0F}; }
    }
  '';
in {
  home.packages = with pkgs; [socat bc netcat playerctl pamixer];
  programs.eww = {
    enable = true;
    configDir = ./config;
  };
  # xdg.configFile."eww/colors.scss".text = colors;
  # home.file.".config/eww/colors.scss".text = colors;
  xdg = {
    configFile = {
      "eww" = {
        source = ./config;
        recursive = true;
      };
      "eww/colors.scss".text = colors;
    };
  };
}
