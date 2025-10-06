return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
			default_file_explorer = true,  -- Startup nvim with oil, not netrw
			columns = {  },  -- Customize columns in oil
			keymaps = {
				["<C-h>"] = false,
				["<C-c>"] = false,
				["<M-h>"] = "actions.select_split",  -- Use Alt + h to 
				["q"] = "actions.close",
			},
			delete_to_trash = true,
			view_options = {
				show_hidden = true,
			},
			skip_confirm_for_simple_edits = true
		})

		-- Keymaps for oil in neovim
		vim.keymap.set(
			"n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory over cur window" }
		)
		vim.keymap.set(
			"n", "<LEADER>-", require("oil").toggle_float, { desc = "Toggle float oil" }
		)
		vim.api.nvim_create_autocmd(
			"FileType",
			{
				pattern = "oil",
				callback = function()
					vim.opt_local.cursorline = true
				end,
			}
		)
	end
}
