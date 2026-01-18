return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<leader>fa",
      function()
        require("telescope.builtin").find_files({
          hidden = true,
          no_ignore = true,
          cwd = vim.fn.getcwd(),
        })
      end,
      desc = "Find All Files (hidden, gitignore)",
    },
  },
}
