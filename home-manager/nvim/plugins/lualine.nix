{theme, ...}: let
  inherit (theme) palette;
  component_left_sep = {
    name = ''
      (function()
        return ""
      end)()
    '';
    color = {
      fg = palette.base02;
      bg = "NONE";
    };
    extraConfig.padding = 0;
  };
  component_right_sep = {
    name = ''
      (function()
        return ""
      end)()
    '';
    color = {
      fg = palette.base02;
      bg = "NONE";
    };
    extraConfig.padding = 0;
  };
  space = {
    name = ''
      (function()
        return " "
      end)()
    '';
    color.bg = "NONE";
    extraConfig.padding = 0;
  };

  surroundWithSeparators = {
    c,
    s ? false,
  }:
    (
      if s
      then [space]
      else []
    )
    ++ [
      component_left_sep
      c
      component_right_sep
      space
    ];

  highlightGroups = [
    "lualine_c_normal"
    "lualine_c_insert"
    "lualine_c_visual"
    "lualine_c_terminal"
    "lualine_c_replace"
    "lualine_c_inactive"
    "lualine_c_command"
  ];

  highlightAttrs = builtins.listToAttrs (
    builtins.map (h: {
      name = h;
      value = {
        fg = "NONE";
        bg = "NONE";
      };
    })
    highlightGroups
  );
in {
  programs.nixvim = {
    highlightOverride =
      {
        SLError = {
          fg = "#${palette.base08}";
          bg = "#${palette.base02}";
        };
        SLWarning = {
          fg = "#${palette.base0E}";
          bg = "#${palette.base02}";
        };
      }
      // highlightAttrs;
    plugins.lualine = {
      enable = true;
      globalstatus = true;
      componentSeparators = {
        left = "";
        right = "";
      };
      sectionSeparators = {
        left = "";
        right = "";
      };
      sections = {
        lualine_a = surroundWithSeparators {
          c = {
            name = "diagnostics";
            color.fg = "#${palette.base0B}";
            extraConfig = {
              sources = ["nvim_diagnostic"];
              sections = ["error" "warn"];
              symbols = {
                error = "%#SLError#" + "" + "%*" + " ";
                warn = "%#SLWarning#" + "" + "%*" + " ";
              };
              colored = false;
              update_in_insert = false;
              always_visible = true;
              padding = 0;
            };
          };
          s = true;
        };
        lualine_b = surroundWithSeparators {
          c = {
            name = "hostname";
            extraConfig.padding = 0;
            color.fg = "#${palette.base0B}";
          };
        };
        lualine_c = surroundWithSeparators {
          c = {
            name = "filename";
            extraConfig.padding = 0;
            color = {
              bg = "#${palette.base02}";
              fg = "#${palette.base0A}";
            };
          };
        };

        lualine_x = surroundWithSeparators {
          c = {
            name = ''
              (function()
                local clients = vim.lsp.buf_get_clients()
                local client_names = ""
                for k, c in pairs(clients) do
                  client_names = client_names .. c.config.name .. " "
                end

                if client_names ~= "" then
                  client_names = client_names:sub(1, -2)
                end

                return client_names
              end)()
            '';
            extraConfig.padding = 0;
            color = {
              fg = "#${palette.base0C}";
              bg = "#${palette.base02}";
            };
          };
        };
        lualine_y = surroundWithSeparators {
          c = {
            name = "filetype";
            extraConfig.padding = 0;
            color.fg = "#${palette.base09}";
          };
        };
        lualine_z =
          surroundWithSeparators
          {
            c = {
              name = ''
                (function()
                  return "%P/%L"
                end)()
              '';
              color = {
                fg = "#${palette.base08}";
                bg = "#${palette.base02}";
              };
              extraConfig.padding = 0;
            };
          };
      };
    };
  };
}
