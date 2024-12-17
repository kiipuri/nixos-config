{
  lib,
  theme,
  ...
}: let
  inherit (lib) mkEnableOption;
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
  imports = [
    ./keymaps.nix
    ./plugins/lsp.nix
    ./plugins/plugins.nix
    (import ./plugins/lualine.nix
      {inherit theme;})
  ];

  options = {
    programs.nixvim.colorschemes.nix-colors = {
      enable = mkEnableOption "nvim-base16 based colorscheme";
    };
  };

  config = {
    programs.nixvim = {
      opts = {
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
        bg = "light";
      };

      clipboard.register = "unnamedplus";

      globals.mapleader = " ";

      colorschemes.base16 = {
        enable = true;
        colorscheme = theme.slug;
      };

      highlightOverride = {
        IlluminatedWordText = {link = "Visual";};
        IlluminatedWordRead = {link = "Visual";};
        IlluminatedWordWrite = {link = "Visual";};
      };

      filetype.extension.http = "http";

      extraConfigLua = ''
        require("gen").setup({
          model = "dolphin-mistral",
          display_mode = "split",
          no_auto_close = true,
        })

        vim.diagnostic.config({virtual_text = false})
      '';

      extraConfigLuaPre = ''
        vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
        vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
        vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
        vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
      '';

      files = fileOpts;
    };
  };
}
