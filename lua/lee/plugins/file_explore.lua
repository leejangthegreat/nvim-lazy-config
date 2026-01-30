return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local telescope_builtin = require("telescope.builtin")
		local oil = require("oil")
		oil.setup({
			default_file_explorer = true,  -- Startup nvim with oil, not netrw
			columns = {
				"icon",
				"size",
				"permissions",
				"mtime",
			},  -- Customize columns in oil
			keymaps = {
				["<C-h>"] = false,
				["<C-c>"] = false,
				["<M-h>"] = {
					"actions.select",  -- Use Alt + h to
					opts = {
						close = false,  -- Do not close original oil buffer
						vertical = true,
						tab = false,
					},
					desc = "Open entry under the cursor in new window",
				},
				["q"] = "actions.close",
				["<Left>"] = "actions.parent",
				["~"] = {
					"<cmd>edit $HOME<CR>",  -- To home dir
					desc = "Open home dir in oil"
				},
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
		vim.keymap.set(
			"n", "<LEADER>F", function()
				telescope_builtin.find_files({
					cwd = oil.get_current_dir(),
					hidden = true,
					follow = true,
				})
			end, { desc = "Find files" }
		)
	end
}
