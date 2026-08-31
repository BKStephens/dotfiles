return {
  {
    "vim-test/vim-test",
    keys = {
      { "<Leader>t", "<cmd>TestFile<CR>", desc = "Test current file" },
      { "<Leader>s", "<cmd>TestNearest<CR>", desc = "Test nearest" },
      { "<Leader>l", "<cmd>TestLast<CR>", desc = "Test last" },
      { "<Leader>a", "<cmd>TestSuite<CR>", desc = "Test suite" },
      { "<Leader>gt", "<cmd>TestVisit<CR>", desc = "Visit test file" },
    },
    init = function()
      vim.g["test#strategy"] = "neovim"
    end,
  },
}
