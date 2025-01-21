{theme, ...}: let
  inherit (theme) palette;
  component_left_sep = {
    __unkeyed-1 = ''
      (function()
        return ""
      end)()
    '';
    color = {
      fg = palette.base02;
      bg = "NONE";
    };
    padding = 0;
    separator = {
      left.__raw = "nil";
      right.__raw = "nil";
    };
  };
  component_right_sep = {
    __unkeyed-1 = ''
      (function()
        return ""
      end)()
    '';
    color = {
      fg = palette.base02;
      bg = "NONE";
    };
    padding = 0;
    separator = {
      left.__raw = "nil";
      right.__raw = "nil";
    };
  };
  space = {
    __unkeyed-1 = ''
      (function()
        return " "
      end)()
    '';
    color.bg = "NONE";
    padding = 0;
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
      settings = {
        options.globalstatus = true;
        componentSeparators = {
          left = "";
          right = "";
        };
        sectionSeparators = {
          left = "";
          right = "";
        };
        sections = {
          lualine_a =
            surroundWithSeparators
            {
              c = {
                __unkeyed-1 = "diagnostics";
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
                color.fg = "#${palette.base0B}";
              };
              s = true;
            };
          lualine_b = surroundWithSeparators {
            c = {
              __unkeyed-1 = "hostname";
              padding = 0;
              color.fg = "#${palette.base0B}";
            };
          };
          lualine_c = surroundWithSeparators {
            c = {
              __unkeyed-1 = "filename";
              padding = 0;
              color = {
                bg = "#${palette.base02}";
                fg = "#${palette.base0A}";
              };
            };
          };

          lualine_x = surroundWithSeparators {
            c = {
              __unkeyed-1 = ''
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
              padding = 0;
              color = {
                fg = "#${palette.base0C}";
                bg = "#${palette.base02}";
              };
            };
          };
          lualine_y = surroundWithSeparators {
            c = {
              __unkeyed-1 = "filetype";
              padding = 0;
              color.fg = "#${palette.base09}";
              separator = {
                left.__raw = "nil";
                right.__raw = "nil";
              };
            };
          };
          lualine_z =
            surroundWithSeparators
            {
              c = {
                __unkeyed-1 = ''
                  (function()
                    return "%P/%L"
                  end)()
                '';
                color = {
                  fg = "#${palette.base08}";
                  bg = "#${palette.base02}";
                };
                padding = 0;
                separator = {
                  left.__raw = "nil";
                  right.__raw = "nil";
                };
              };
            };
        };
      };
    };
  };
}
