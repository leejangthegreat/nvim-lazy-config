return {
	{
		"folke/snacks.nvim",  -- docs @ https://github.com/folke/snacks.nvim/blob/main/docs
		priority = 1000,
		lazy = false,
		opts = {
			quickfile = {
				enabled = true,
				exclude = { "latex" },
			},
			picker = {
				enable = true,
				matchers = {
					frecency = true,
					cwd_bonus = true,
				},
				formatters = {
					file = {
						filename_first = true,
						filename_only = false,
						icon_width = 2
					}
				},
				win = {
					input = {
						keys = {
							["<C-c>"] = { "close", mode = {"n", "i"} },
						},
					},
					list = {
						keys = {
							["<C-c>"] = "close",
						}
					},
				},
				layout = {
					preset = "telescope",
					cycle = false,
				},
				layouts = {
					select = {
						preview = false,
						layout = {
							backdrop = false,
							width = 0.6,
							min_width = 80,
							height = 0.4,
							min_height = 10,
							box = "vertical",
							border = "rounded",
							title = "{title}",
							title_pos = "center",
							{ win = "input", height = 1, border = "bottom" },
							{ win = "list", border = "none" },
							{ win = "preview", title = "{preview}", width = 0.6, height = 0.4, border = "top" },
						}
					},
					telescope = {
						reverse = false,  -- Search bar at bottom
						layout = {
							box = "horizontal",
							backdrop = false,
							width = 0.8,
							height = 0.9,
							border = "none",
							{
								box = "vertical",
								-- wins' setting sequence is sub-windows showing sequence !!
								{ win = "input", height = 1, border = "rounded", title = "{title} {live} {flags}", title_pos = "center" },
								{ win = "list", title = "Results ", title_pos = "center", border = "rounded" },
							},
							{
								win = "preview",
								title = "{preview:Preview}",
								width = 0.5,
								border = "rounded",
								title_pos = "center"
							},
						},
					},
					ivy = {
						layout = {
							box = "vertical",
							backdrop = false,
							width = 0,
							height = 0.4,
							position = "bottom",
							border = "top",
							title = " {title} {live} {flags} ",
							title_pos = "left",
							{ win = "input", height = 1, border = "bottom" },
							{
								box = "horizontal",
								{ win = "list", border = "none" },
								{ win = "preview", title = "{preview}", width = 0.5, border = "left" },
							},
						},
					},
				},
			},
		},
		keys = {
			{ "<LEADER>rn", function() require("snacks").rename.rename_file() end, desc = "Rename current file" },
			{ "<LEADER>bd", function() require("snacks").bufdelete() end, desc = "Delete or close buffer (confirm)" },

			-- LazyGit
			{ "<LEADER>go", function() require("snacks").lazygit() end, desc = "Open LazyGit" },
			{ "<LEADER>gl", function() require("snacks").lazygit.log() end, desc = "Open LazyGit Logs" },

			-- Snacks Picker
			{ "<LEADER>pf", function() require("snacks").picker.files() end, desc = "Find files (Snacks Picker)" },
			{ "<LEADER>pc", function() require("snacks").picker.files({ cwd = vim.fn.stdpath('config') }) end, desc = "Find config file" },
			{ "<LEADER>ps", function() require("snacks").picker.grep() end, desc = "Grep match words" },
			{ "<LEADER>pS", function() require("snacks").picker.grep_word() end, mode = { "n", "x" }, desc = "Search visual selection or word" },
			{ "<LEADER>pk", function() require("snacks").picker.keymaps({ layout = "ivy" }) end, desc = "Search keymaps (picker)" },
			{ "<LEADER>pb", function() require("snacks").picker.git_branches({ layout = "select" }) end, desc = "Pick and switch git branches" },
			{ "<LEADER>ph", function() require("snacks").picker.help() end, desc = "Picker help pages" },
		}
	},
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPre", "BufNewFile" },
		keys = {
			{ "<LEADER>pt", function() require("snacks").picker.todo_comments() end, desc = "Todo" },
			{ "<LEADER>pT", function() require("snakcs").picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo / Fix / FixMe" }
		}
	}
}

