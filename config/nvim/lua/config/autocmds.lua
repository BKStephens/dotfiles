local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local general = augroup("GeneralAutocmds", { clear = true })

-- When editing a file, always jump to the last known cursor position
autocmd("BufReadPost", {
  group = general,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count and vim.bo[args.buf].filetype ~= "gitcommit" then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Jump to last known cursor position on file open",
})

autocmd({ "BufRead", "BufNewFile" }, {
  group = general,
  pattern = "Appraisals",
  callback = function()
    vim.bo.filetype = "ruby"
  end,
})

autocmd({ "BufRead", "BufNewFile" }, {
  group = general,
  pattern = { ".jscsrc", ".jshintrc", ".eslintrc" },
  callback = function()
    vim.bo.filetype = "json"
  end,
})

autocmd({ "BufRead", "BufNewFile" }, {
  group = general,
  pattern = {
    "aliases.local",
    "zshenv.local",
    "zlogin.local",
    "zlogout.local",
    "zshrc.local",
    "zprofile.local",
    "*/zsh/configs/*",
  },
  callback = function()
    vim.bo.filetype = "sh"
  end,
})

autocmd({ "BufRead", "BufNewFile" }, {
  group = general,
  pattern = "gitconfig.local",
  callback = function()
    vim.bo.filetype = "gitconfig"
  end,
})

autocmd({ "BufRead", "BufNewFile" }, {
  group = general,
  pattern = "tmux.conf.local",
  callback = function()
    vim.bo.filetype = "tmux"
  end,
})

autocmd({ "BufRead", "BufNewFile" }, {
  group = general,
  pattern = "vimrc.local",
  callback = function()
    vim.bo.filetype = "vim"
  end,
})

-- Spell checking and formatting for Markdown and Git commit messages
autocmd("FileType", {
  group = general,
  pattern = { "markdown", "gitcommit" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- Allow stylesheets to autocomplete hyphenated words
autocmd("FileType", {
  group = general,
  pattern = { "css", "scss", "sass" },
  callback = function()
    vim.opt_local.iskeyword:append("-")
  end,
})

-- Fast exit: terminate LSP client processes immediately on exit so large servers (like OmniSharp) don't hang :q
autocmd({ "QuitPre", "VimLeavePre", "ExitPre" }, {
  group = general,
  callback = function()
    -- Remove Neovim's default blocking LSP shutdown hook
    for _, a in ipairs(vim.api.nvim_get_autocmds({ event = "VimLeavePre" })) do
      if a.desc and a.desc:find("vim%.lsp") then
        pcall(vim.api.nvim_del_autocmd, a.id)
      end
    end

    -- Forcibly terminate all LSP clients immediately with SIGKILL
    for _, client in ipairs(vim.lsp.get_clients()) do
      if vim.lsp._watchfiles and vim.lsp._watchfiles.cancel then
        pcall(vim.lsp._watchfiles.cancel, client.id)
      end

      -- Extract child process PID from transport and kill immediately
      if client.rpc and client.rpc.terminate then
        local i = 1
        while true do
          local name, val = debug.getupvalue(client.rpc.terminate, i)
          if not name then break end
          if name == "client" and val.transport and val.transport.sysobj then
            local pid = val.transport.sysobj.pid
            if pid and pid > 0 then
              pcall(vim.uv.kill, pid, 9)
              pcall(vim.fn.system, "pkill -9 -P " .. pid)
            end
            break
          end
          i = i + 1
        end
        pcall(client.rpc.terminate)
      end

      pcall(function() client:stop(true) end)
    end

    -- Kill any OmniSharp instances tied to this Neovim process PID
    pcall(vim.fn.system, string.format("pkill -9 -f 'OmniSharp.*--hostPID %d'", vim.fn.getpid()))
  end,
  desc = "Force terminate LSP client processes immediately on exit",
})
