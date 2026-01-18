return {
  {
    "folke/snacks.nvim",
    opts = {
      zen = {
        enabled = true,
        -- toggle options
        toggles = {
          dim = false, -- disable dimming
        },

        -- window layout settings
        win = {
          -- backdrop controls transparency/dimming
          backdrop = {
            transparent = false, -- do not let buffer show through
            blend = 20, -- maximum solid background
          },

          -- size of the Zen window
          width = 0.9,
        },

        -- turn off any additional UI hiding
        opts = {
          number = false,
          relativenumber = false,
          cursorline = true,
        },
      },
    },
  },
}
