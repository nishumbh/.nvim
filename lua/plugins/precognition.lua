return {
	{
		"tris203/precognition.nvim",
		event = "VeryLazy",
		opts = {
			startVisible = false,
			-- This makes the hints subtle so they don't distract you from your code
			highlightColor = { link = "Comment" },
		},
		config = function(_, opts)
			require("precognition").setup(opts)

			-- Set a toggle keybind: <leader>tp (Toggle Precognition)
			vim.keymap.set("n", "<leader>tp", function()
				require("precognition").toggle()
			end, { desc = "Toggle Precognition" })
		end,
	},
}
