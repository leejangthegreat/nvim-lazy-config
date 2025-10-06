return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },  -- Only activated when open / new
		build = ":TSUpdate",
		config = function()
			local tree_sitter = require("nvim-treesitter.configs")
			tree_sitter.setup({
				highlight = {
					enable = true,
				},
				indent = {
					enable = true,
				},
				ensure_installed = {
					"json",
					"javascript",
					"typescript",
					"go",
					"yaml",
					"html",
					"css",
					"desktop",
					"python",
					"http",
					"markdown",
					"markdown_inline",
					"bash",
					"lua",
					"vim",
					"dockerfile",
					"gitignore",
					"query",
					"vimdoc",
					"c",
					"make",
					"cmake",
					"meson",
					"ninja",
					"cpp",
					"cuda",
					"fortran",
					"java",
					"rust",
					"cairo"
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<LEADER>i",
						node_incremental = "<LEADER>i",
						scope_incremental = false
					}
				}
			})
		end
	},
}
