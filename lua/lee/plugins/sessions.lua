return {
	"folke/persistence.nvim",
	event = "BufReadPre", -- only start saving when an actual file was opened
	opts = {},
	-- stylua: ignore
	keys = {
		{ "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
		{ "<leader>qc", function() require("persistence").select() end,              desc = "Select Session" },
		{ "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
		{ "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
	}
,
}
