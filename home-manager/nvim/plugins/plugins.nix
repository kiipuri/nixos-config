{
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.vimUtils) buildVimPlugin;
  inherit (pkgs) fetchFromGitHub;
in {
  programs.nixvim = {
    plugins = {
      auto-session = {
        enable = true;
        settings = {
          enable = true;
          auto_restore = true;
          auto_save = true;
          suppressed_dirs = [config.home.homeDirectory];
        };
      };
      floaterm.enable = true;
      ollama = {
        model = "dolphin-mistral";
      };
      markdown-preview.enable = true;
      gitsigns.enable = true;
      luasnip = {
        enable = true;
        fromLua = [{paths = ./snippets;}];
      };
      ts-autotag = {
        enable = true;
        settings.enable_close_on_slash = false;
      };
      web-devicons.enable = true;
      telescope = {
        enable = true;
        enabledExtensions = ["ui-select"];
        extensions = {
          undo = {
            enable = true;
            settings = {
              side_by_side = true;
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
        };
        settings = {
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
        settings.indent.enable = true;
        nixvimInjections = true;
      };
      treesitter-refactor = {
        enable = true;
        smartRename.enable = true;
        navigation.enable = true;
      };
      treesitter-context = {
        enable = false;
        settings = {
          max_lines = 2;
          trim_scope = "outer";
        };
      };
      noice = {
        enable = true;
        settings = {
          lsp = {
            signature.enabled = false;
            override = {
              "vim.lsp.util.convert_input_to_markdown_lines" = true;
              "vim.lsp.util.stylize_markdown" = true;
              "cmp.entry.get_documentation" = true;
            };
          };
          presets = {
            bottom_search = true;
            command_palette = true;
            long_message_to_split = true;
            inc_rename = true;
            lsp_doc_border = false;
          };
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
      comment.enable = true;
      indent-blankline.enable = true;
      nvim-lightbulb = {
        enable = true;
        settings.autocmd.enabled = true;
      };
      nvim-autopairs.enable = true;
      inc-rename.enable = true;
      illuminate.enable = true;
      trouble.enable = true;
      which-key.enable = true;
      nvim-colorizer.enable = true;
      nvim-surround.enable = true;
      rustaceanvim = {
        enable = true;
        settings.rust-analyzer.check.command = "clippy";
      };
      neo-tree = {
        enable = true;
        popupBorderStyle = "rounded";
      };
      neoscroll = {
        enable = true;
        settings = {
          mappings = ["<C-u>" "<C-d>" "<C-b>" "<C-f>" "<C-y>" "<C-e>" "zt" "zz" "zb"];
          hide_cursor = true;
          stop_eof = true;
          use_local_scrolloff = false;
          respect_scrolloff = true;
          cursor_scrolls_alone = false;
        };
      };
      yazi.enable = true;
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
    extraPlugins = with pkgs.vimPlugins; [
      yuck-vim
      telescope-ui-select-nvim
      vim-snippets
      nvim-web-devicons
      neoscroll-nvim
      lsp_signature-nvim
      nvim-notify
      tabout-nvim
      (buildVimPlugin {
        pname = "gen.nvim";
        version = "2024-04-01";
        src = fetchFromGitHub {
          owner = "David-Kunz";
          repo = "gen.nvim";
          rev = "b68997c2fb9f5c15285556b27fce823514297dee";
          sha256 = "sha256-NRqzH3RTTMnMctqR2TPy5q6it2izvvHUEO263U2VCAg=";
        };
      })
    ];
    extraConfigLuaPre = ''
      luasnip = require("luasnip")
      require("luasnip.loaders.from_snipmate").lazy_load()
    '';
    extraConfigLua = ''
      ${builtins.readFile ./tabout.lua}
    '';
  };
}
