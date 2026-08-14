return {
	-- add gruvbox
	{ "ellisonleao/gruvbox.nvim" },
	{ "rebelot/kanagawa.nvim" },
	{ "rose-pine/neovim" },
	-- Configure LazyVim to load gruvbox
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "kanagawa",
		},
	},
}
