return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        transparent_mode = true,
        contrast = "hard",
        palette_overrides = {},
        overrides = {
          SignColumn = { bg = "NONE" },
          VertSplit = { bg = "NONE", fg = "#504945" },
          NormalFloat = { bg = "NONE" },
          FloatBorder = { bg = "NONE" },
        },
      })
      vim.cmd.colorscheme("gruvbox")
    end,
  },
}
