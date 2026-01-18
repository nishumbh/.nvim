return {
  {
    "tpope/vim-dadbod",
    lazy = true,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    init = function()
      -- 1. Setup the Autocmd for Completion
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          require("cmp").setup.buffer({
            sources = {
              { name = "vim-dadbod-completion" },
              { name = "buffer" },
            },
          })
        end,
      })

      -- 2. DBUI Settings
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_win_width = 35
      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_hide_schemas = { "information_schema", "pg_*" }
      vim.g.db_ui_table_helpers = {
        postgresql = {
          Count = 'select count(*) from "{table}"',
          Describe = '\\d+ "{table}"',
          Find = "select * from {table} where col_name like :searchparam",
        },
      }
    end,
  },
}
