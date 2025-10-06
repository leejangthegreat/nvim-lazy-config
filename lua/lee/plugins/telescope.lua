return {
	"nvim-telescope/telescope.nvim",
	branch="0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },  -- For input performance
		"nvim-tree/nvim-web-devicons",
	},

	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")

		telescope.load_extension("fzf")

		telescope.setup({
			defaults = {
				path_display = { "smart" },  -- Shorten file path when proper
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
					},
				},
			}
		})

		-- Keymaps
		vim.keymap.set("n", "<LEADER>pr", "<cmd>Telescope oldfiles<CR>", { desc = "Fuzzy find recent files" })
		vim.keymap.set(
			"n", "<LEADER>pw", function()
				local word = vim.fn.expand("<cword>")  -- Recognize word under cursor
				builtin.grep_string({ search = word })
			end, { desc = "Find word under cursor" }
		)

	end
}
