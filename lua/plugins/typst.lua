return {
	"chomosuke/typst-preview.nvim",
	lazy = false, -- or ft = 'typst'
	version = "1.*",
	opts = {
		port = 23635,
	}, -- lazy.nvim will implicitly calls setup {}
	require("lspconfig").tinymist.setup({
		settings = {
			outputPath = "$root/target/$dir/$name",
			exportPdf = "onSave",
		},
	}),
}
