return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		local ensure_installed = {
			"ts_ls",
			"html",
			"cssls",
			"tailwindcss",
			"svelte",
			"lua_ls",
			"graphql",
			"emmet_ls",
			"pyright",
			-- clangd usa o do sistema (/usr/bin/clangd 19.1.7) para evitar EEXIST broken symlink
			-- "clangd",
			"rust_analyzer",
		}

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = ensure_installed,
		})
	end,
}
