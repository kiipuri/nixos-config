{...}: {
  programs.nixvim.keymaps = [
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
}
