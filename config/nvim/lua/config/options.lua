local opt = vim.opt

vim.g.autoformat = false
vim.g.snacks_animate = false

-- Encoding & Clipboard
opt.encoding = "utf-8"
opt.clipboard = { "unnamed", "unnamedplus" } -- System clipboard integration (macOS & Linux)

-- Backups & Swap
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- Command & History
opt.history = 50
opt.ruler = true
opt.showcmd = true
opt.incsearch = true
opt.laststatus = 2
opt.autowrite = true
opt.modeline = false

-- Indentation (2 spaces, softtabs)
opt.tabstop = 2
opt.shiftwidth = 2
opt.shiftround = true
opt.expandtab = true

-- Whitespace display
opt.list = true
opt.listchars = {
  tab = "»·",
  trail = "·",
  nbsp = "·",
}

-- Text formatting & layout
opt.joinspaces = false
opt.number = true
opt.numberwidth = 5
opt.splitbelow = true
opt.splitright = true
opt.scrolloff = 5
opt.showtabline = 2

-- Completion & Wildmenu
opt.wildmode = "list:longest,list:full"
opt.wildignore:append({ "*/tmp/*", "*/.git/*", "*/deps/*", "*.beam" })
opt.completeopt = { "menu", "menuone", "noselect" }

-- Spell check default file
opt.spellfile = vim.fn.expand("$HOME/.vim-spell-en.utf-8.add")
opt.complete:append("kspell")

-- Diff options (always vertical diffs)
opt.diffopt:remove("internal")
opt.diffopt:append("vertical")

-- True color support & Syntax
opt.termguicolors = true
vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")
