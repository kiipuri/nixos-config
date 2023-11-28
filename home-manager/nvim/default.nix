{
  config,
  pkgs,
  lib,
  theme,
  ...
}: let
  inherit (lib) mkEnableOption;
  inherit (pkgs.vimUtils) buildVimPlugin;
  inherit (pkgs) fetchFromGitHub;
  inherit (theme) colors;
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
      };

      plugins = {
        floaterm.enable = true;

        markdown-preview.enable = true;

        null-ls = {
          enable = true;
          sources = {
            diagnostics = {
              shellcheck.enable = true;
              statix.enable = true;
            };
            code_actions = {
              shellcheck.enable = true;
              gitsigns.enable = false;
            };
            formatting = {
              alejandra.enable = true;
              black.enable = true;
              stylua.enable = true;
              prettier.enable = true;
            };
          };
          onAttach = ''
            function(client, bufnr)
              if client.supports_method("textDocument/formatting") then
                vim.api.nvim_create_autocmd("BufWritePre", {
                  buffer = bufnr,
                  callback = function()
                    vim.lsp.buf.format()
                  end,
                })
              end
            end
          '';
        };

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

        indent-blankline = {
          enable = true;
          useTreesitter = true;
          showCurrentContext = true;
          showCurrentContextStart = false;
        };

        lsp = {
          enable = true;
          servers = {
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
          };
        };

        lspkind = {
          enable = true;
          cmp = {
            enable = true;
          };
        };

        nvim-lightbulb = {
          enable = true;
          autocmd.enabled = true;
        };

        nvim-autopairs = {
          enable = true;
        };

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
        nvim-cmp = {
          enable = true;

          snippet.expand = "luasnip";

          mapping = {
            "<CR>" = "cmp.mapping.confirm({select = true })";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
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
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" })
            '';
            "<C-j>" = "cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i'})";
            "<C-k>" = "cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i'})";
          };

          sources = [
            {name = "luasnip";}
            {name = "nvim_lsp";}
            {name = "path";}
            {name = "buffer";}
            {name = "calc";}
            {name = "zsh";}
          ];
        };
      };

      extraConfigLua = ''
        vim.cmd[[set bg=light]]
        local base16 = require("base16-colorscheme")
        base16.setup({
          base00 = "#${colors.base00}", base01 = "#${colors.base01}", base02 = "#${colors.base02}",
          base03 = "#${colors.base03}", base04 = "#${colors.base04}", base05 = "#${colors.base05}",
          base06 = "#${colors.base06}", base07 = "#${colors.base07}", base08 = "#${colors.base08}",
          base09 = "#${colors.base09}", base0A = "#${colors.base0A}", base0B = "#${colors.base0B}",
          base0C = "#${colors.base0C}", base0D = "#${colors.base0D}", base0E = "#${colors.base0E}",
          base0F = "#${colors.base0F}"
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
      '';

      globals = {
        mapleader = " ";
      };

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

      maps.normal = {
        "<leader>ld" = "<cmd>lua vim.lsp.buf.definition()<cr>";
        "<leader>ls" = "<cmd>lua vim.diagnostic.open_float()<cr>";
        "<leader>lc" = "<cmd>lua vim.lsp.buf.code_action()<cr>";
        "<leader>lh" = "<cmd>lua vim.lsp.buf.hover()<cr>";
        "<leader>lr" = "<cmd>lua vim.lsp.buf.rename()<cr>";

        "<leader>e" = "<cmd>Telescope diagnostics<cr>";
        "<leader>tf" = "<cmd>Telescope find_files<cr>";
        "<leader>tg" = "<cmd>Telescope git_files<cr>";
        "<leader>ts" = "<cmd>Telescope lsp_document_symbols<cr>";
        "<leader>tb" = "<cmd>Telescope buffers<cr>";
        "<leader>tr" = "<cmd>Telescope lsp_references<cr>";
        "<leader>tl" = "<cmd>Telescope live_grep<cr>";
        "<leader>u" = "<cmd>Telescope undo<cr>";

        "<leader>jf" = "<cmd>lua require'harpoon.ui'.nav_file(1)<cr>";
        "<leader>jd" = "<cmd>lua require'harpoon.ui'.nav_file(2)<cr>";
        "<leader>js" = "<cmd>lua require'harpoon.ui'.nav_file(3)<cr>";
        "<leader>ja" = "<cmd>lua require'harpoon.ui'.nav_file(4)<cr>";
        "<leader>jm" = "<cmd>lua require'harpoon.mark'.add_file()<cr>";
        "<leader>jt" = "<cmd>lua require'harpoon.ui'.toggle_quick_menu()<cr>";

        "<leader>f" = "<cmd>FloatermToggle<cr>";

        "<leader>n" = "<cmd>Neotree toggle float<cr>";

        "<leader>h" = "<cmd>noh<cr>";

        "<c-j>" = "<c-w>j";
        "<c-k>" = "<c-w>k";
        "<c-h>" = "<c-w>h";
        "<c-l>" = "<c-w>l";
      };

      maps.insert = {
        "<c-s>" = "<cmd>lua vim.lsp.buf.signature_help()<cr>";
      };

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
