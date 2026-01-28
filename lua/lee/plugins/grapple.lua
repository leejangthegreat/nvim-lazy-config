return {
	"cbochs/grapple.nvim",
    dependencies = {
        { "nvim-tree/nvim-web-devicons", lazy = true }
    },
	opts = {
		scope = "git",
	},
	event = { "BufReadPost", "BufNewFile" },
	cmd = "Grapple",
	keys = {
		{ "<LEADER>a", "<cmd>Grapple toggle<CR>", desc = "Tag a file in grapple" },
		{ "<C-e>", "<cmd>Grapple toggle_tags<CR>", desc = "Toggle grapple tags menu" },
		{ "<C-S-p>", "<cmd>Grapple cycle_tags prev<CR>", desc = "Navigate to previous tagged file in grapple" },
		{ "<C-S-n>", "<cmd>Grapple cycle_tags next<CR>", desc = "Navigate to next tagged file in grapple" },
	}
}
