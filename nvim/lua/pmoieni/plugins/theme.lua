return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			transparent_background = true,
			integrations = {
				cmp = true,
				gitsigns = true,
				treesitter = true,
				mini = true,
				mason = true,
				dap = {
					enabled = true,
					enable_ui = true,
				},
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
					},
					underlines = {
						errors = { "underline" },
						hints = { "underline" },
						warnings = { "underline" },
						information = { "underline" },
					},
					inlay_hints = {
						background = true,
					},
				},
				telescope = {
					enabled = true,
				},
				which_key = true,
			},
		})

		vim.cmd([[colorscheme catppuccin]])
	end
}
