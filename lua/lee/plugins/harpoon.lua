return {
	-- Add files to hot map
	"thePrimeagen/harpoon",
	enable = true,
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim"
	},

	config = function()
		local harpoon = require("harpoon")
		harpoon:setup({
			global_settings = {
				save_on_toggle = true,
				save_on_change = true,
			},
		})

		-- Navigation
		vim.keymap.set(
			"n", "<LEADER>a", function()
				harpoon:list():add()
			end, { desc = "Harpoon add file to hot list" }
		)

		vim.keymap.set(
			"n", "<C-e>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "Show harpoon quick file list" }
		)

		-- Toggle prev / next buffer stored within harpoon list
		vim.keymap.set(
			"n", "<C-S-P>", function()
				harpoon:list():prev()
			end, { desc = "Navigate to previous hot file in harpoon" }
		)
		vim.keymap.set(
			"n", "<C-S-N>", function()
				harpoon:list():next()
			end, { desc = "Navigate to next hot file in harpoon" }
		)

	end
}
