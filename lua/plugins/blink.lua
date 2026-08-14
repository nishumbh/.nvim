return {
	"saghen/blink.cmp",
	version = "*",
	dependencies = {
		"L3MON4D3/LuaSnip",
		"rafamadriz/friendly-snippets",
		"kristijanhusak/vim-dadbod-completion",
	},

	opts = {
		sources = {
			default = {
				"lsp",
				"path",
				"snippets",
				"buffer",
				"dadbod",
			},

			providers = {
				dadbod = {
					name = "Dadbod",
					module = "vim_dadbod_completion.blink",
				},
			},
		},
	},
}
