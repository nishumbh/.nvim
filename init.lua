-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.setrun")

vim.cmd("colorscheme kanagawa-dragon") -- retrobox
vim.opt.relativenumber = false
vim.opt.signcolumn = "auto:1"
