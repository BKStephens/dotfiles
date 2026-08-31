local map = vim.keymap.set

-- Switch between the last two files immediately (Alternate buffer)
map("n", "<Leader><Leader>", "<C-^>", { desc = "Switch to last buffer" })
map("n", "<Leader><Space>", "<C-^>", { desc = "Switch to last buffer" })

-- Quicker window movement
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Quick save
map("n", "<Leader>w", "<cmd>w<CR>", { desc = "Save current buffer" })

-- Clipboard helpers
map({ "n", "v" }, "<Leader>y", '"+y', { desc = "Yank to system clipboard" })
map({ "n", "v" }, "<Leader>d", '"+d', { desc = "Delete to system clipboard" })
map("n", "<Leader>p", '"+p', { desc = "Paste from system clipboard" })
map("n", "<Leader>P", '"+P', { desc = "Paste before from system clipboard" })
map("v", "<Leader>p", '"+p', { desc = "Paste from system clipboard" })
map("v", "<Leader>P", '"+P', { desc = "Paste before from system clipboard" })

-- Muscle memory enforcers ("Get off my lawn")
map("n", "<Left>", '<cmd>echoerr "Use h"<CR>', { desc = "Disable Left arrow" })
map("n", "<Right>", '<cmd>echoerr "Use l"<CR>', { desc = "Disable Right arrow" })
map("n", "<Up>", '<cmd>echoerr "Use k"<CR>', { desc = "Disable Up arrow" })
map("n", "<Down>", '<cmd>echoerr "Use j"<CR>', { desc = "Disable Down arrow" })

-- Diagnostic navigation
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
map("n", "<Leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic error" })
map("n", "<Leader>q", vim.diagnostic.setqflist, { desc = "Add diagnostics to quickfix" })

-- Global LSP Navigation Shortcuts (FzfLua / Native LSP)
map("n", "gd", "<cmd>FzfLua lsp_definitions<CR>", { desc = "Go to definition" })
map("n", "gI", "<cmd>FzfLua lsp_implementations<CR>", { desc = "Go to implementation" })
map("n", "gr", "<cmd>FzfLua lsp_references<CR>", { desc = "Find references" })
map("n", "gt", "<cmd>FzfLua lsp_typedefs<CR>", { desc = "Go to type definition" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
map("n", "<Leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<Leader>do", vim.lsp.buf.code_action, { desc = "Code action (coc compatibility)" })
map("n", "<Leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map({ "n", "i" }, "<C-\\>", vim.lsp.buf.signature_help, { desc = "Signature help" })
