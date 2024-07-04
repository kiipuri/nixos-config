{...}: {
  programs.nixvim.plugins = {
    lsp-format.enable = true;
    none-ls = {
      enable = true;
      sources = {
        code_actions = {
          statix.enable = true;
        };
        diagnostics = {
          statix.enable = true;
        };
        formatting = {
          shfmt.enable = true;
          shfmt.withArgs = "{ args = {'-i', 4} }";
          alejandra.enable = true;
          black.enable = true;
        };
      };
    };

    lsp = {
      enable = true;
      servers = {
        nixd = {
          enable = false;
          settings.formatting.command = ["nixpkgs-fmt"];
        };
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
        cssls.enable = true;
        svelte.enable = true;
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
