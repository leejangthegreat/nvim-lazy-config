return {
	"rmagatti/auto-session",
	config = function()
		local auto_session = require("auto-session")

		auto_session.setup({
			auto_restore_enable = false,
			auto_session_suppress_dirs = { "~/", "~/Download", "~/Document", "~/Desktop", "/", "/usr", "/opt" },
		})

		-- keymaps
		vim.keymap.set(
			"n", "<LEADER>rw", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" }
		)

		vim.keymap.set(
			"n", "<LEADER>rs", "<cmd>SessionSave<CR>", { desc = "Save session" }
		)
	end
}
