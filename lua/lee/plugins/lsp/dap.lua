local _default_km_opts = { noremap = true, silent = true }

local function _make_opts(overrides)
	return vim.tbl_extend("force", _default_km_opts, overrides or {})
end

return {
	{
		"jay-babu/mason-nvim-dap.nvim",
		event = "VeryLazy",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		config = function()
			require("mason-nvim-dap").setup({
				ensure_installed = { "python", "codelldb" },
				automatic_installation = true,
				handlers = {},
			})

			-- DAP Keymap Config
			local dap = require("dap")
			local widgets = require("dap.ui.widgets")

			vim.keymap.set("n", "<F6>", function()
				dap.continue()
			end, _make_opts({ desc = "Resume execution when thread stopped" }))

			vim.keymap.set("n", "<F7>", function()
				dap.step_over()
			end, _make_opts({ desc = "Run for a step" }))

			vim.keymap.set("n", "<F11>", function()
				dap.step_into()
			end, _make_opts({ desc = "Step into a function or method if possible" }))

			vim.keymap.set("n", "<F12>", function()
				dap.step_out()
			end, _make_opts({ desc = "Step out of function or method if possible" }))

			vim.keymap.set("n", "<LEADER>B", function()
				dap.toggle_breakpoint()
			end, _make_opts({ desc = "Toggle breakpoint at current line" }))

			vim.keymap.set("n", "<LEADER>bl", function()
				dap.set_breakpoint(nil, nil, vim.fn.input("Log breakpoint info: "))
			end, _make_opts({ desc = "Set a breakpoint with message (override)" }))

			vim.keymap.set("n", "<LEADER>br", function()
				dap.repl.toggle()
			end, _make_opts({ desc = "Toggle debugger REPL" }))

			vim.keymap.set("n", "<LEADER>bv", function()
				widgets.hover()
			end, _make_opts({ desc = "Evaluate the expression and display result" }))

			vim.keymap.set("n", "<LEADER>bf", function()
				widgets.centered_float(widgets.frames)
			end, _make_opts({ desc = "Display debug frame view (centered)" }))

			vim.keymap.set("n", "<LEADER>bs", function()
				widgets.centered_float(widgets.scopes)
			end, _make_opts({ desc = "Display debug scope view (centered)" }))

			vim.keymap.set("n", "<LEADER>bS", function()
				widgets.centered_float(widgets.sessions)
			end, _make_opts({ desc = "Display debug session view (centered)" }))

			vim.keymap.set("n", "<LEADER>bt", function()
				widgets.centered_float(widgets.threads)
			end, _make_opts({ desc = "Display debug thread view (centered)" }))

		end,
	},
}
