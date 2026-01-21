M = {
	"pwntester/octo.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/snacks.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		picker = "snacks",
	},
	config = function()
		require("octo").setup({ enable_builtin = true })
		vim.cmd([[hi OctoEditable guibg=none]])
	end,
	keys = {
		{ "<leader>gO", "<cmd>Octo<cr>", desc = "Open Octo" },
	},
}

return {}
