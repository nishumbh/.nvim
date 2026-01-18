return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "mfussenegger/nvim-dap-python",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
    },
    keys = {
      -- 1. Django & Python Launchers
      {
        "<leader>dPr",
        function()
          require("dap").run({
            type = "python",
            request = "launch",
            name = "Django Runserver",
            program = vim.loop.cwd() .. "/manage.py",
            args = { "runserver", "--noreload" },
            django = true,
            justMyCode = false,
          })
        end,
        desc = "Run Django Server",
      },
      {
        "<leader>dPt",
        function()
          require("dap-python").test_method()
        end,
        desc = "Debug Method",
        ft = "python",
      },
      {
        "<leader>dPc",
        function()
          require("dap-python").test_class()
        end,
        desc = "Debug Class",
        ft = "python",
      },

      -- 2. Advanced Breakpoints
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dB",
        function()
          -- Get the word under the cursor to help pre-fill
          local var = vim.fn.expand("<cword>")

          -- Prompt for condition only, pre-filling the variable name
          local condition = vim.fn.input("Breakpoint condition for [" .. var .. "]: ", var .. " == ")

          -- If the user didn't just escape or leave it at the pre-filled string
          if condition ~= "" and condition ~= (var .. " == ") then
            require("dap").set_breakpoint(condition)
            vim.notify("Conditional breakpoint set: " .. condition)
          end
        end,
        desc = "Conditional Breakpoint",
      },
      {
        "<leader>dC",
        function()
          require("dap").clear_breakpoints()
        end,
        desc = "Clear All Breakpoints",
      },

      -- 3. Inspection & UI
      {
        "<space>?",
        function()
          require("dapui").eval(nil, { enter = true })
        end,
        desc = "Inspect Variable",
      },
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "Toggle Debug UI",
      },

      -- 4. Exception Toggles (Cycles: All -> Uncaught -> None)
      {
        "<leader>de",
        function()
          local dap = require("dap")
          if not _G.dap_exception_state or _G.dap_exception_state == "none" then
            dap.set_exception_breakpoints({ "raised", "uncaught" })
            _G.dap_exception_state = "all"
            vim.notify("DAP: Break on ALL exceptions", vim.log.levels.INFO)
          elseif _G.dap_exception_state == "all" then
            dap.set_exception_breakpoints({ "uncaught" })
            _G.dap_exception_state = "uncaught"
            vim.notify("DAP: Break on UNCAUGHT exceptions", vim.log.levels.INFO)
          else
            dap.set_exception_breakpoints({})
            _G.dap_exception_state = "none"
            vim.notify("DAP: Exception breakpoints CLEARED", vim.log.levels.WARN)
          end
        end,
        desc = "Toggle Exception Breakpoints",
      },
    },

    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local dap_python = require("dap-python")

      -- Initialize Virtual Text
      require("nvim-dap-virtual-text").setup({
        commented = true,
        show_stop_reason = true,
      })

      -- Schedule UI Setup to avoid E565 "Not allowed to change text or window"
      vim.schedule(function()
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
      end)

      -- Python Adapter Path Logic
      local path = vim.fn.has("win32") == 1 and LazyVim.get_pkg_path("debugpy", "/venv/Scripts/pythonw.exe")
        or LazyVim.get_pkg_path("debugpy", "/venv/bin/python")

      dap_python.setup(path)

      -- Global configurations for Python/Django
      -- These ensure every session allows template debugging and library stepping
      for _, config in ipairs(dap.configurations.python or {}) do
        config.django = true
        config.justMyCode = false
      end
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = {
      handlers = {
        python = function() end, -- Let dap-python handle it
      },
    },
  },
}
