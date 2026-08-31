return {
  {
    "seblj/roslyn.nvim",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = {
      filewatching = "auto",
      broad_search = true,
    },
    config = function(_, opts)
      require("roslyn").setup(opts)

      -- roslyn.nvim registers razor forwarding handlers on textDocument/* methods which break
      -- Neovim's native lsp.buf handlers (gI, gd, gt, etc.) for non-razor C# buffers.
      -- Clearing them restores Neovim's standard LSP request routing.
      local roslyn_cfg = vim.lsp.config["roslyn"]
      if roslyn_cfg and roslyn_cfg.handlers then
        for _, method in ipairs({
          "textDocument/implementation",
          "textDocument/definition",
          "textDocument/typeDefinition",
          "textDocument/references",
          "textDocument/reference",
          "textDocument/hover",
          "textDocument/completion",
          "textDocument/formatting",
          "textDocument/rangeFormatting",
          "textDocument/onTypeFormatting",
          "textDocument/foldingRange",
          "textDocument/documentHighlight",
          "textDocument/documentColor",
          "textDocument/colorPresentation",
        }) do
          roslyn_cfg.handlers[method] = nil
        end
      end

      vim.lsp.config("roslyn", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        settings = {
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_code_lens = true,
          },
        },
      })

      vim.lsp.enable("roslyn")

      -- Re-trigger FileType for any C#/Razor buffers already loaded before roslyn initialized
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) then
          local ft = vim.bo[bufnr].filetype
          if ft == "cs" or ft == "razor" then
            vim.api.nvim_exec_autocmds("FileType", {
              buffer = bufnr,
              modeline = false,
            })
          end
        end
      end
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
      { "<Leader>b", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
      { "<Leader>B", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Debug: Set Conditional Breakpoint" },
      { "<Leader>du", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- netcoredbg adapter configuration
      dap.adapters.coreclr = {
        type = "executable",
        command = vim.fn.exepath("netcoredbg") ~= "" and "netcoredbg" or vim.fn.expand("~/.local/share/nvim/mason/bin/netcoredbg"),
        args = { "--interpreter=vscode" },
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
          end,
        },
      }
    end,
  },
}
