{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
  cfg = config.programs.nixvim.colorschemes.nix-colors;
  theme = config.colorScheme;
  inherit (theme) colors;
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
        # cot = ["menu" "menuone" "noselect"];
        updatetime = 100;
        listchars = "tab:>-,lead:·,nbsp:␣,trail:•";
        timeout = true;
        timeoutlen = 300;
        clipboard = "unnamedplus";
      };

      extraConfigLua =
        ''
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
        ''
        + builtins.readFile ./config.lua;

      globals = {
        mapleader = " ";
      };

      extraPlugins = with pkgs.vimPlugins; [
        telescope-ui-select-nvim
        vim-snippets
        markdown-preview-nvim
        nvim-base16
        vim-illuminate
        lualine-nvim
        nvim-web-devicons
        neoscroll-nvim
        vim-surround
        null-ls-nvim
      ];

      maps.normal = {
        "<leader>ld" = "<cmd>lua vim.lsp.buf.definition()<cr>";
        "<leader>ls" = "<cmd>lua vim.diagnostic.open_float()<cr>";
        "<leader>lc" = "<cmd>lua vim.lsp.buf.code_action()<cr>";
        "<leader>lh" = "<cmd>lua vim.lsp.buf.hover()<cr>";
        "<leader>e" = "<cmd>Telescope diagnostics<cr>";
        "<leader>ff" = "<cmd>Telescope find_files<cr>";
        "<leader>fg" = "<cmd>Telescope git_files<cr>";

        "<leader>jf" = "<cmd>lua require'harpoon.ui'.nav_file(1)<cr>";
        "<leader>jd" = "<cmd>lua require'harpoon.ui'.nav_file(2)<cr>";
        "<leader>js" = "<cmd>lua require'harpoon.ui'.nav_file(3)<cr>";
        "<leader>ja" = "<cmd>lua require'harpoon.ui'.nav_file(4)<cr>";
        "<leader>jm" = "<cmd>lua require'harpoon.mark'.add_file()<cr>";
        "<leader>jt" = "<cmd>lua require'harpoon.ui'.toggle_quick_menu()<cr>";

        "<leader>h" = "<cmd>noh<cr>";
      };
      #maps.normal = helpers.mkModeMaps {silent = true;} {
      #"ft" = "<cmd>Neotree<CR>";
      #"fG" = "<cmd>Neotree git_status<CR>";
      #"fR" = "<cmd>Neotree remote<CR>";
      #"fc" = "<cmd>Neotree close<CR>";
      #"bp" = "<cmd>Telescope buffers<CR>";
      #
      #"<C-s>" = "<cmd>Telescope spell_suggest<CR>";
      #"mk" = "<cmd>Telescope keymaps<CR>";
      #"fg" = "<cmd>Telescope git_files<CR>";
      #
      #"gr" = "<cmd>Telescope lsp_references<CR>";
      #"gI" = "<cmd>Telescope lsp_implementations<CR>";
      #"gW" = "<cmd>Telescope lsp_workspace_symbols<CR>";
      #"gF" = "<cmd>Telescope lsp_document_symbols<CR>";
      #"ge" = "<cmd>Telescope diagnostics bufnr=0<CR>";
      #"gE" = "<cmd>Telescope diagnostics<CR>";
      #
      #"<leader>rn" = {
      #action = ''
      #function()
      #return ":IncRename " .. vim.fn.expand("<cword>")
      #end
      #'';
      #lua = true;
      #expr = true;
      #};
      #"<leader>ld" = "<cmd>lua vim.lsp.buf.definition()<cr>";
      #"<leader>ls" = "<cmd>lua vim.diagnostic.open_float()<cr>";
      #"<leader>lc" = "<cmd>lua vim.lsp.buf.code_action()<cr>";
      #"<leader>lh" = "<cmd>lua vim.lsp.buf.hover()<cr>";
      #};

      plugins.null-ls = {
        enable = false;
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
      plugins.gitsigns.enable = true;
      # plugins.gitmessenger.enable = true;

      plugins.luasnip = {
        enable = true;
      };

      extraConfigLuaPre = ''
        local has_words_before = function()
          unpack = unpack or table.unpack
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end
        local luasnip = require("luasnip")
      '';

      plugins.nvim-cmp = {
        enable = true;

        snippet.expand = "luasnip";

        mapping = {
          "<CR>" = "cmp.mapping.confirm({select = true })";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<Tab>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
              -- they way you will only jump inside the snippet region
              elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end, { "i", "s" })
          '';
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

      plugins.telescope = {
        enable = true;
        enabledExtensions = ["ui-select"];
        extensionConfig = {
          ui-select = {
            __raw = ''
                require("telescope.themes").get_dropdown {
                -- even more opts
              }
            '';
          };
        };
        extraOptions = {
          defaults.layout_strategy = "vertical";
        };
      };

      plugins.treesitter = {
        enable = true;
        indent = true;

        nixvimInjections = true;

        #grammarPackages = with config.plugins.treesitter.package.passthru.builtGrammars; [
        #arduino
        #bash
        #c
        #cpp
        #cuda
        #dart
        #devicetree
        #diff
        #dockerfile
        #gitattributes
        #gitcommit
        #gitignore
        #git_rebase
        #html
        #ini
        #json
        #lalrpop
        #latex
        #lua
        #make
        #markdown
        #markdown_inline
        #meson
        #ninja
        #nix
        #python
        #regex
        #rst
        #rust
        #slint
        #sql
        #tlaplus
        #toml
        #vim
        #vimdoc
        #yaml
        #];
      };

      plugins.treesitter-refactor = {
        enable = true;
        smartRename = {
          enable = true;
        };
        navigation = {
          enable = true;
        };
      };

      plugins.treesitter-context = {
        enable = false;
        maxLines = 2;
        trimScope = "outer";
      };

      plugins.harpoon.enable = true;

      plugins.comment-nvim = {
        enable = true;
      };

      plugins.neo-tree = {
        enable = true;
      };

      plugins.indent-blankline = {
        enable = true;

        useTreesitter = true;

        showCurrentContext = true;
        showCurrentContextStart = false;
      };

      plugins.lsp = {
        enable = true;

        # keymaps = {
        #   silent = true;
        #
        #   lspBuf = {
        #     "gd" = "definition";
        #     "gD" = "declaration";
        #     "ca" = "code_action";
        #     "ff" = "format";
        # "K" = "hover";
        #   };
        # };

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
        };
      };

      plugins.lspkind = {
        enable = true;
        cmp = {
          enable = true;
        };
      };

      plugins.nvim-lightbulb = {
        enable = true;
        autocmd.enabled = true;
      };

      #plugins.lsp_signature = {
      #enable = true;
      #};

      plugins.inc-rename = {
        enable = true;
      };

      plugins.trouble = {
        enable = true;
      };

      extraConfigLuaPost = ''
        require("luasnip.loaders.from_snipmate").lazy_load()

        -- local null_ls = require("null-ls")
        -- null_ls.setup({
        --   sources = {
        --     -- null_ls.builtins.formatting.shfmt.with({
        --     --   extra_args = { "-i", "4", "-s", "-ci", "-sr" },
        --     -- }),
        --     null_ls.builtins.formatting.alejandra,
        --     null_ls.builtins.formatting.stylua,
        --     null_ls.builtins.formatting.prettier,
        --     null_ls.builtins.formatting.black,
        --
        --     null_ls.builtins.diagnostics.shellcheck,
        --     null_ls.builtins.diagnostics.statix,
        --     null_ls.builtins.diagnostics.selene,
        --
        --     null_ls.builtins.code_actions.shellcheck,
        --     null_ls.builtins.code_actions.gitsigns,
        --   }
        -- })
          -- diagnostics = {
          --   shellcheck.enable = true;
          --   statix.enable = true;
          -- };
          -- code_actions = {
          --   shellcheck.enable = true;
          --   gitsigns.enable = false;
          -- };
          -- formatting = {
          --   alejandra.enable = true;
          --   black.enable = true;
          --   stylua.enable = true;
          --   #shfmt.enable = true;
          --   prettier.enable = true;
          -- };
        -- local null_ls = require("null-ls")
        --
        -- local helpers = require("null-ls.helpers")
      '';

      plugins.which-key.enable = true;
      plugins.nvim-colorizer.enable = true;

      files."ftplugin/nix.lua" = {
        options = {
          tabstop = 2;
          shiftwidth = 2;
          expandtab = true;
        };
      };
    };
  };
}
