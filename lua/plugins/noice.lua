return {
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
      },
      views = {
        cmdline_popup = {
          position = {
            row = "99%",
            col = "50%",
          },
          size = {
            width = "100%",
          },
          border = {
            style = "none",
          },
        },
      },
    },
  },
}
