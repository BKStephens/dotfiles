return {
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {
    "tpope/vim-repeat",
    event = "VeryLazy",
  },
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "github/copilot.vim",
    event = "InsertEnter",
    init = function()
      vim.g.copilot_no_tab_map = true
      vim.keymap.set("i", "<C-J>", 'copilot#Accept("<CR>")', {
        expr = true,
        replace_keycodes = false,
        desc = "Copilot accept suggestion",
      })
    end,
  },
}
