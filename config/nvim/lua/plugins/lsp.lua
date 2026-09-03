return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
      ui = {
        border = "rounded",
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "ts_ls",
        "eslint",
        "jsonls",
        "html",
        "cssls",
        "lua_ls",
      },
      automatic_installation = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local mason_lspconfig = require("mason-lspconfig")

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local has_blink, blink = pcall(require, "blink.cmp")
      if has_blink then
        capabilities = blink.get_lsp_capabilities(capabilities)
      else
        local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
        if has_cmp then
          capabilities = cmp_lsp.default_capabilities(capabilities)
        end
      end

      -- Disable semantic tokens globally to prevent OmniSharp crashing and highlight clearing
      if vim.lsp.semantic_tokens and vim.lsp.semantic_tokens.enable then
        pcall(vim.lsp.semantic_tokens.enable, false)
      end

      -- Global LspAttach autocommand for buffer keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client then
            client.exit_timeout = 0
            if client.flags then
              client.flags.exit_timeout = 0
            end
            if client.name == "omnisharp" then
              client.server_capabilities.semanticTokensProvider = nil
              if vim.lsp.semantic_tokens and vim.lsp.semantic_tokens.enable then
                pcall(vim.lsp.semantic_tokens.enable, false, { bufnr = event.buf })
              end
            end
          end

          -- Remove Neovim's default blocking LSP shutdown hook from VimLeavePre
          for _, a in ipairs(vim.api.nvim_get_autocmds({ event = "VimLeavePre" })) do
            if a.desc and a.desc:find("vim%.lsp") then
              pcall(vim.api.nvim_del_autocmd, a.id)
            end
          end

          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          map("n", "gt", vim.lsp.buf.type_definition, "Go to type definition")
          map("n", "gI", vim.lsp.buf.implementation, "Find implementations")
          map("n", "gr", "<cmd>FzfLua lsp_references<CR>", "Find references")
          map("n", "K", vim.lsp.buf.hover, "Hover documentation")
          map("n", "<Leader>ca", vim.lsp.buf.code_action, "Code action")
          map("n", "<Leader>do", vim.lsp.buf.code_action, "Code action (coc compatibility)")
          map("n", "<Leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map({ "n", "i" }, "<C-\\>", vim.lsp.buf.signature_help, "Signature help")
        end,
      })


      -- Diagnostic styling
      vim.diagnostic.config({
        virtual_text = { prefix = "●" },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      mason_lspconfig.setup({
        ensure_installed = {
          "ts_ls",
          "eslint",
          "jsonls",
          "html",
          "cssls",
          "lua_ls",
        },
        automatic_installation = true,
        handlers = {
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities,
            })
          end,

          ["lua_ls"] = function()
            lspconfig.lua_ls.setup({
              capabilities = capabilities,
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { "vim" },
                  },
                  workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                  },
                  telemetry = { enable = false },
                },
              },
            })
          end,

          ["omnisharp"] = function() end,
        },
      })

      -- Automatically attach LSP to any buffer already open at startup
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].filetype ~= "" then
          vim.api.nvim_exec_autocmds("FileType", {
            buffer = bufnr,
            modeline = false,
          })
        end
      end
    end,
  },
}
