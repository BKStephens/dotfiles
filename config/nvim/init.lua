-- Leader key must be set before any plugins/mappings load
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load core configuration modules
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
