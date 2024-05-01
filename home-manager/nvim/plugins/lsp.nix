{...}: {
  programs.nixvim.plugins = {
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
        nixd = {
          enable = false;
          settings.formatting.command = "nixpkgs-fmt";
        };
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
  };
}
