return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "helix",
		delay = 200,
		icons = {
			mappings = true,
		},
		spec = {
			{ "<leader>s", group = "split/window" },
			{ "<leader>t", group = "theme" },
			{ "<leader>c", group = "code/lsp" },
			{ "<leader>x", desc = "Close buffer" },
			{ "<leader>n", desc = "New tab" },
			{ "<C-n>", desc = "File explorer" },
			{ "<Tab>", desc = "Next buffer" },
			{ "<S-Tab>", desc = "Prev buffer" },
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
