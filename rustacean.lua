return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    lazy = false, -- This plugin is already lazy
    config = function()
      local mason_registry = require("mason-registry")
      local codelldb = mason_registry.get_package("codelldb")
      local extension_path = codelldb:get_install_path() .. "/extension/"
      local codelldb_path = extension_path .. "adapter/codelldb"
      local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
      local cfg = require("rustaceanvim.config")

      vim.g.rustaceanvim = {
        dap = {
          adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
        },
        server = {
          cmd = function()
            local ra_binary = mason_registry.is_installed("rust-analyzer")
                and mason_registry.get_package("rust-analyzer"):get_install_path() .. "/rust-analyzer"
              or "rust-analyzer"
            return { ra_binary } -- You can add args to the list, such as '--log-file'
          end,
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      dap.configurations.rust = {
        {
          type = "codelldb",
          name = "Launch",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
          runInTerminal = true,
        },
      }
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.before.event_initialized["dapui_config"] = function()
        dapui.setup({
          icons = { expanded = "▾", collapsed = "▸" },
          mappings = {
            expand = "<CR>",
            open = "o",
            remove = "d",
            edit = "e",
          },
          sidebar = {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          tray = {
            elements = { "repl" },
            size = 10,
            position = "bottom",
          },
          floating = {
            max_height = nil,
            max_width = nil,
            mappings = {
              close = { "q", "<Esc>" },
            },
          },
          windows = { indent = 1 },
        })
      end
      dap.listeners.before.attach["dapui_open"] = function()
        dapui.open()
      end
      dap.listeners.before.launch["dapui_open"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_close"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_close"] = function()
        dapui.close()
      end
    end,
  },
}
