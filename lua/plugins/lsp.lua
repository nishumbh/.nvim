return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Global LSP behavior
      inlay_hints = {
        enabled = false,
      },

      servers = {
        basedpyright = {
          settings = {
            python = {
              pythonPath = vim.fn.exepath("python"),
            },
            basedpyright = {
              analysis = {
                typeCheckingMode = "basic",
                diagnosticMode = "openFilesOnly",
                autoImportCompletions = false,
                useLibraryCodeForTypes = true,

                strictListInference = false,
                strictSetInference = false,
                strictDictionaryInference = false,
                strictParameterNoneValue = false,

                diagnosticSeverityOverrides = {
                  reportOptionalMemberAccess = false,
                  reportOptionalSubscript = false,
                  reportOptionalCall = false,
                },
              },
            },
          },
        },

        clangd = {
          cmd = (function()
            local cmd = {
              "clangd",

              -- Core behavior
              "--background-index",
              "--all-scopes-completion",
              "--function-arg-placeholders=false",

              -- Reduce noise
              "--clang-tidy=false",
              -- "--suggest-missing-includes=false",
              "--limit-results=20",
              "--limit-references=200",

              -- Make fallback parsing sane
              "--fallback-style=LLVM",
              "--header-insertion=never",
            }

            if vim.loop.os_uname().sysname == "Windows_NT" then
              table.insert(cmd, "--query-driver=C:/msys64/ucrt64/bin/*")
            end

            return cmd
          end)(),
        },
      },
    },
  },
}
