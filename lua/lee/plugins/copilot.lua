return {
	"zbirenbaum/copilot.lua",
	dependencies = {
		"copilotlsp-nvim/copilot-lsp",
	},
	cmd = "Copilot",
	event = "InsertEnter",
	config = function ()
		-- <LEADER>co: Toggle preview panel
		local suggest = require("copilot.suggestion")
		require("copilot").setup({
			panel = {
				enabled = true,
				auto_refresh = false,
				keymap = {
					jump_prev = "<LEADER>c[",
					jump_next = "<LEADER>c]",
					accept = "<LEADER>ca",
					toggle = "<M-o>",
				},
				layout = {
					position = "right",
					ratio = 0.5,
				}
			},
			suggestion = {
				enabled = true,
				auto_trigger = false,
				hide_during_completion = true,
				debounce = 75,
				trigger_on_accept = true,
				keymap = {
					accept = "<M-l>",
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<M-u>"
				}
			},
			copilot_node_command = vim.fn.expand("$HOME") .. "/.nvm/versions/node/v22.21.1/bin/node",
			workspace_folders = {},
			copilot_model = "",
		})

		-- Toggle auto-suggestion
		vim.keymap.set(
			{ "i", "n" }, "<M-c>", suggest.toggle_auto_trigger,
			{ desc = "Toggle automatic suggestion" }
		)
	end
}
