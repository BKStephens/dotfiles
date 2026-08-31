local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { buffer = true, desc = desc })
end

-- Jump to previous/next method or class
map("n", "[[", "<cmd>FzfLua lsp_document_symbols<CR>", "Navigate C# symbols")
map("n", "]]", "<cmd>FzfLua lsp_document_symbols<CR>", "Navigate C# symbols")
