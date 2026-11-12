return {
  {
    "seblj/roslyn.nvim",
    lazy = false,
    dependencies = {
      "mason-org/mason.nvim",
    },
    opts = {
      filewatching = "auto",
      broad_search = true,
    },
    config = function(_, opts)
      require("roslyn").setup(opts)

      -- Support Microsoft.Build.Traversal (dirs.proj) projects when no .sln/.slnx exists
      local function parse_dirs_proj(dirs_proj_path, seen, results)
        seen = seen or {}
        results = results or {}
        local normalized = vim.fs.normalize(dirs_proj_path)
        if seen[normalized] or not vim.uv.fs_stat(normalized) then
          return results
        end
        seen[normalized] = true

        local base_dir = vim.fs.dirname(normalized)
        local file = io.open(normalized, "r")
        if not file then return results end
        local content = file:read("*a")
        file:close()

        for include in content:gmatch('[Ii]nclude%s*=%s*["\']([^"\']+)["\']') do
          local rel_path = include:gsub("\\", "/")
          local full_path = vim.fs.normalize(base_dir .. "/" .. rel_path)
          if full_path:match("%.csproj$") then
            if vim.uv.fs_stat(full_path) and not vim.list_contains(results, full_path) then
              table.insert(results, full_path)
            end
          elseif full_path:match("%.proj$") then
            parse_dirs_proj(full_path, seen, results)
          end
        end

        return results
      end

      local function find_top_dirs_proj(path)
        local matches = vim.fs.find("dirs.proj", { upward = true, path = path, limit = math.huge })
        if #matches > 0 then
          return matches[#matches]
        end
        return nil
      end

      local target_mod = require("roslyn.target")
      local orig_resolve = target_mod.resolve

      target_mod.resolve = function(bufnr)
        local decision = orig_resolve(bufnr)
        if decision.kind == "solution" or decision.kind == "reuse" then
          return decision
        end

        local buf_name = vim.api.nvim_buf_get_name(bufnr)
        if buf_name and buf_name ~= "" then
          local top_dirs = find_top_dirs_proj(buf_name)
          if top_dirs then
            local projects = parse_dirs_proj(top_dirs)
            if #projects > 0 then
              return {
                kind = "project",
                root_dir = vim.fs.dirname(top_dirs),
                projects = projects,
              }
            end
          end
        end

        return decision
      end

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

      local dotnet_bin = vim.fn.exepath("dotnet") ~= "" and vim.fn.exepath("dotnet") or "/usr/local/share/dotnet/dotnet"
      local dotnet_root = vim.fs.dirname(dotnet_bin)
      local roslyn_dll = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "roslyn", "libexec", "Microsoft.CodeAnalysis.LanguageServer.dll")
      vim.lsp.config("roslyn", {
        cmd = {
          dotnet_bin,
          roslyn_dll,
          "--stdio",
          "--clientProcessId",
          tostring(vim.uv.os_getpid()),
          "--extensionLogDirectory",
          vim.fs.joinpath(vim.fn.stdpath("log"), "roslyn"),
        },
        cmd_env = {
          DOTNET_ROOT = dotnet_root,
          Configuration = vim.env.Configuration or "Debug",
          TMPDIR = vim.env.TMPDIR and vim.fn.resolve(vim.env.TMPDIR) or nil,
        },
        capabilities = capabilities,
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
      "mason-org/mason.nvim",
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
