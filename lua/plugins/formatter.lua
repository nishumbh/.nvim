return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      -- python = { "black" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      json = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
    },

    -- format_on_save = {
    --   lsp_fallback = true,
    --   timeout_ms = 500,
    -- },
  },
}
