return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        contrast = "hard",
        palette_overrides = {},
        overrides = {
          SignColumn = { bg = "NONE" },
          VertSplit = { bg = "#32302f", fg = "#504945" },
        },
      })
      vim.cmd.colorscheme("gruvbox")
    end,
  },
}
