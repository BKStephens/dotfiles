-- Leader key must be set before any plugins/mappings load
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Core configuration modules
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Bootstrap lazy.nvim, LazyVim, and user plugins
require("config.lazy")
