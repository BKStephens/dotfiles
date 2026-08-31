return {
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite", "GBrowse" },
    keys = {
      { "<Leader>gs", "<cmd>Git<CR>", desc = "Git status (Fugitive)" },
      { "<Leader>gd", "<cmd>Gdiffsplit<CR>", desc = "Git diff split" },
    },
    dependencies = {
      "tpope/vim-rhubarb",
    },
  },
}
