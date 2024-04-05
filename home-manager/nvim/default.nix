{
  config,
  pkgs,
  lib,
  theme,
  themeName,
  ...
}: let
  inherit (lib) mkEnableOption;
  inherit (pkgs.vimUtils) buildVimPlugin;
  inherit (pkgs) fetchFromGitHub;
  inherit (theme) palette;
  configString = import ./config/config.nix;

  fileTypes = [
    "nix"
    "javascript"
    "typescript"
    "typescriptreact"
  ];

  fileOpts = builtins.listToAttrs (
    builtins.map (f: {
      name = "ftplugin/${f}.lua";
      value = {
        options = {
          tabstop = 2;
          shiftwidth = 2;
          expandtab = true;
        };
      };
    })
    fileTypes
  );
in {
  options = {
    programs.nixvim.colorschemes.nix-colors = {
      enable = mkEnableOption "nvim-base16 based colorscheme";
    };
  };

  config = {
    programs.nixvim = {
      options = {
        termguicolors = true;
        number = true;
        relativenumber = true;
        tabstop = 4;
        shiftwidth = 4;
        scrolloff = 7;
        expandtab = true;
        title = true;
        cursorline = true;
        signcolumn = "yes";
        cmdheight = 2;
        updatetime = 100;
        listchars = "tab:>-,lead:·,nbsp:␣,trail:•";
        timeout = true;
        timeoutlen = 300;
        clipboard = "unnamedplus";
      };

      colorschemes.base16 = {
        enable = true;
        colorscheme = themeName;
      };

      plugins = {
        floaterm.enable = true;
        markdown-preview.enable = true;

        gitsigns.enable = true;

        luasnip.enable = true;
        ts-autotag = {
          enable = true;
          extraOptions.enable_close_on_slash = false;
        };

        telescope = {
          enable = true;
          enabledExtensions = ["ui-select"];
          extensions = {
            undo = {
              enable = true;
              sideBySide = true;
              mappings = {
                i = {
                  "<cr>" = "yank_additions";
                  "<S-cr>" = "yank_deletions";
                  "<C-cr>" = "restore";
                };
                n = {
                  "<cr>" = "yank_additions";
                  "<S-cr>" = "yank_deletions";
                  "<C-cr>" = "restore";
                };
              };
            };
          };
          extraOptions = {
            defaults.layout_strategy = "vertical";
            undo = {
              layout_strategy = "horizontal";
              layout_config = {
                preview_width = 0.7;
              };
            };
          };
        };

        treesitter = {
          enable = true;
          indent = true;
          nixvimInjections = true;
        };

        treesitter-refactor = {
          enable = true;
          smartRename.enable = true;
          navigation.enable = true;
        };

        treesitter-context = {
          enable = false;
          maxLines = 2;
          trimScope = "outer";
        };

        noice = {
          enable = true;

          lsp.signature.enabled = false;
          lsp.override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
            "cmp.entry.get_documentation" = true;
          };
          presets = {
            bottom_search = true;
            command_palette = true;
            long_message_to_split = true;
            inc_rename = true;
            lsp_doc_border = false;
          };
        };

        harpoon.enable = true;
        harpoon.package = buildVimPlugin {
          pname = "harpoon";
          version = "2023-09-16";
          src = fetchFromGitHub {
            owner = "ThePrimeagen";
            repo = "harpoon";
            rev = "c1aebbad9e3d13f20bedb8f2ce8b3a94e39e424a";
            sha256 = "sha256-pSnFx5fg1llNlpTCV4hoo3Pf1KWnAJDRVSe+88N4HXM=";
          };
        };
        comment-nvim.enable = true;

        indent-blankline.enable = true;

        efmls-configs = {
          enable = true;
          setup = {
            nix = {
              formatter = "alejandra";
              linter = "statix";
            };
            sh = {
              formatter = "shfmt";
              linter = "shellcheck";
            };
            typescript.formatter = "prettier_d";
            python.formatter = "black";
          };
        };

        lsp = {
          enable = true;
          servers = {
            efm.extraOptions.init_options.documentFormatting = true;
            nil_ls = {
              enable = true;
              settings = {
                formatting.command = ["alejandra" "--quiet"];
              };
            };
            bashls.enable = true;
            eslint.enable = true;
            tsserver.enable = true;
            lua-ls.enable = true;
            omnisharp.enable = true;
            csharp-ls.enable = true;
            pylsp.enable = true;
            pyright.enable = true;
          };
          onAttach = ''
            if client.supports_method("textDocument/formatting") then
              vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                  vim.lsp.buf.format()
                end,
              })
            end
          '';
          capabilities = ''
            require("cmp_nvim_lsp").default_capabilities()
          '';
        };

        lspkind = {
          enable = true;
          cmp.enable = true;
        };

        nvim-lightbulb = {
          enable = true;
          settings.autocmd.enabled = true;
        };

        nvim-autopairs.enable = true;

        inc-rename.enable = true;
        trouble.enable = true;
        which-key.enable = true;
        nvim-colorizer.enable = true;
        surround.enable = true;
        lualine.enable = true;
        neo-tree = {
          enable = true;
          popupBorderStyle = "rounded";
        };
        cmp = {
          enable = true;

          settings = {
            snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";

            mapping = {
              "<CR>" = "cmp.mapping.confirm({select = true })";
              "<C-d>" = "cmp.mapping.scroll_docs(-4)";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";
              "<C-Space>" = "cmp.mapping.complete()";
              "<Tab>" = ''
                cmp.mapping(function(fallback)
                  if luasnip.expand_or_locally_jumpable() then
                    luasnip.expand_or_jump()
                  else
                    fallback()
                  end
                end, { "i", "s" })
              '';
              # "<Tab>" = ''
              #   cmp.mapping(function(fallback)
              #     if cmp.visible() then
              #       cmp.select_next_item()
              #     -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
              #     -- they way you will only jump inside the snippet region
              #     elseif luasnip.expand_or_locally_jumpable() then
              #       luasnip.expand_or_jump()
              #     elseif has_words_before() then
              #       cmp.complete()
              #     else
              #       fallback()
              #     end
              #   end, { "i", "s" })
              # '';
              "<S-Tab>" = ''
                cmp.mapping(function(fallback)
                  if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                  end
                end, { "i", "s" })
              '';
              # "<S-Tab>" = ''
              #   cmp.mapping(function(fallback)
              #     if cmp.visible() then
              #       cmp.select_prev_item()
              #     elseif luasnip.jumpable(-1) then
              #       luasnip.jump(-1)
              #     else
              #       fallback()
              #     end
              #   end, { "i", "s" })
              # '';
              "<C-j>" = "cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i'})";
              "<C-k>" = "cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i'})";
            };

            sources = [
              {name = "luasnip";}
              {name = "nvim_lsp";}
              {name = "vim-dadbod-completion";}
              {name = "path";}
              {name = "buffer";}
              {name = "calc";}
              {name = "zsh";}
            ];
          };
        };
      };

      extraConfigLua = ''
        vim.cmd[[set bg=light]]
        local base16 = require("base16-colorscheme")
        base16.setup({
          base00 = "#${palette.base00}", base01 = "#${palette.base01}", base02 = "#${palette.base02}",
          base03 = "#${palette.base03}", base04 = "#${palette.base04}", base05 = "#${palette.base05}",
          base06 = "#${palette.base06}", base07 = "#${palette.base07}", base08 = "#${palette.base08}",
          base09 = "#${palette.base09}", base0A = "#${palette.base0A}", base0B = "#${palette.base0B}",
          base0C = "#${palette.base0C}", base0D = "#${palette.base0D}", base0E = "#${palette.base0E}",
          base0F = "#${palette.base0F}"
        })

        local colors = base16.colors
        ${configString}

        -- require("telescope").load_extension("undo")
        vim.filetype.add({
          extension = {http = "http"}
        })

        local rest = require("rest-nvim")
        rest.setup()
        vim.keymap.set('n', '<leader>xr', rest.run)

        local config = require("session_manager.config")
        require("session_manager").setup({
          autoload_mode = config.AutoloadMode.CurrentDir
        })
      '';

      globals.mapleader = " ";

      extraPlugins = with pkgs.vimPlugins; [
        telescope-ui-select-nvim
        vim-snippets
        vim-illuminate
        nvim-web-devicons
        neoscroll-nvim
        lsp_signature-nvim
        nvim-notify
        rest-nvim
        (buildVimPlugin {
          pname = "tabout.nvim";
          version = "2023-09-18";
          src = fetchFromGitHub {
            owner = "abecodes";
            repo = "tabout.nvim";
            rev = "0d275c8d25f32457e67b5c66d6ae43f26a61bce5";
            sha256 = "sha256-Ltys1BVWWBHuv1GOCFQ0wMYf36feRRePAiH85tbx9Ic=";
          };
        })
        (buildVimPlugin {
          pname = "neovim-session-manager";
          version = "2023-11-14";
          src = fetchFromGitHub {
            owner = "Shatur";
            repo = "neovim-session-manager";
            rev = "68dde355a4304d83b40cf073f53915604bdd8e70";
            sha256 = "sha256-WOJQ6RIibOby+Pmzr6kQxcT2NCGrq1roWkh4QKJECks=";
          };
        })
      ];

      keymaps = [
        {
          key = "<leader>ld";
          action = "<cmd>lua vim.lsp.buf.definition()<cr>";
          mode = "n";
        }
        {
          key = "<leader>ls";
          action = "<cmd>lua vim.diagnostic.open_float()<cr>";
          mode = "n";
        }
        {
          key = "<leader>lc";
          action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
          mode = "n";
        }
        {
          key = "<leader>lh";
          action = "<cmd>lua vim.lsp.buf.hover()<cr>";
          mode = "n";
        }
        {
          key = "<leader>lr";
          action = "<cmd>lua vim.lsp.buf.rename()<cr>";
          mode = "n";
        }

        {
          key = "<leader>e";
          action = "<cmd>Telescope diagnostics<cr>";
          mode = "n";
        }
        {
          key = "<leader>tf";
          action = "<cmd>Telescope find_files<cr>";
          mode = "n";
        }
        {
          key = "<leader>tg";
          action = "<cmd>Telescope git_files<cr>";
          mode = "n";
        }
        {
          key = "<leader>ts";
          action = "<cmd>Telescope lsp_document_symbols<cr>";
          mode = "n";
        }
        {
          key = "<leader>tb";
          action = "<cmd>Telescope buffers<cr>";
          mode = "n";
        }
        {
          key = "<leader>tr";
          action = "<cmd>Telescope lsp_references<cr>";
          mode = "n";
        }
        {
          key = "<leader>tl";
          action = "<cmd>Telescope live_grep<cr>";
          mode = "n";
        }
        {
          key = "<leader>u";
          action = "<cmd>Telescope undo<cr>";
          mode = "n";
        }

        {
          key = "<leader>oo";
          action = "<cmd>Gen<cr>";
          mode = "";
        }
        {
          key = "<leader>or";
          action = ":Gen Review_Code<cr>";
          mode = "";
        }

        {
          key = "<leader>jf";
          action = "<cmd>lua require'harpoon.ui'.nav_file(1)<cr>";
          mode = "n";
        }
        {
          key = "<leader>jd";
          action = "<cmd>lua require'harpoon.ui'.nav_file(2)<cr>";
          mode = "n";
        }
        {
          key = "<leader>js";
          action = "<cmd>lua require'harpoon.ui'.nav_file(3)<cr>";
          mode = "n";
        }
        {
          key = "<leader>ja";
          action = "<cmd>lua require'harpoon.ui'.nav_file(4)<cr>";
          mode = "n";
        }
        {
          key = "<leader>jm";
          action = "<cmd>lua require'harpoon.mark'.add_file()<cr>";
          mode = "n";
        }
        {
          key = "<leader>jt";
          action = "<cmd>lua require'harpoon.ui'.toggle_quick_menu()<cr>";
          mode = "n";
        }

        {
          key = "<leader>f";
          action = "<cmd>FloatermToggle<cr>";
          mode = "n";
        }

        {
          key = "<leader>n";
          action = "<cmd>Neotree toggle float<cr>";
          mode = "n";
        }

        {
          key = "<leader>h";
          action = "<cmd>noh<cr>";
          mode = "n";
        }

        {
          key = "<c-j>";
          action = "<c-w>j";
          mode = "n";
        }
        {
          key = "<c-k>";
          action = "<c-w>k";
          mode = "n";
        }
        {
          key = "<c-h>";
          action = "<c-w>h";
          mode = "n";
        }
        {
          key = "<c-l>";
          action = "<c-w>l";
          mode = "n";
        }
        {
          key = "<c-s>";
          action = "<cmd>lua vim.lsp.buf.signature_help()<cr>";
          mode = "i";
        }
      ];

      extraConfigLuaPre = ''
        local has_words_before = function()
          unpack = unpack or table.unpack
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end
        local luasnip = require("luasnip")
      '';

      extraConfigLuaPost = ''
        require("luasnip.loaders.from_snipmate").lazy_load()
      '';

      files = fileOpts;
    };
  };
}
