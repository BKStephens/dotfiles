return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<C-p>", "<cmd>FzfLua files<CR>", desc = "Find files (FZF)" },
      { "\\", "<cmd>FzfLua live_grep<CR>", desc = "Live grep (ripgrep)" },
      { "<Leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Search buffers" },
      { "<Leader>,", "<cmd>FzfLua buffers<CR>", desc = "Search buffers" },
      { "<Leader>fr", "<cmd>FzfLua oldfiles<CR>", desc = "Recent files" },
      { "<Leader>fc", "<cmd>FzfLua commands<CR>", desc = "Search commands" },
      { "<Leader>fs", "<cmd>FzfLua lsp_document_symbols<CR>", desc = "Document symbols" },
      { "<Leader>fS", "<cmd>FzfLua lsp_workspace_symbols<CR>", desc = "Workspace symbols" },
    },
    opts = {
      winopts = {
        height = 0.85,
        width = 0.85,
        preview = {
          layout = "flex",
        },
      },
      keymap = {
        builtin = {
          ["<C-d>"] = "preview-page-down",
          ["<C-u>"] = "preview-page-up",
        },
      },
    },
  },
}
