return {
	-- For full mason plug list, go to https://mason-registry.dev/registry/list
	"williamboman/mason.nvim",
	lazy = false,
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"neovim/nvim-lspconfig",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		-- Enable Icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			automatic_enable = false,
			-- Language servers to install
			-- Ref: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
			ensure_installed = {
				"lua_ls",
				-- "gopls",  -- Go language server
				"pylsp",
				"rust_analyzer",
				-- "java_language_server",
				"clangd",
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				-- Formatter
				"stylua",
				"clang-format",
				"ruff",
				-- Linter
				-- ruff
				-- Debugger Adapter (moved to mason-nvim-dap in dap.lua)
			},
		})
	end,
}
