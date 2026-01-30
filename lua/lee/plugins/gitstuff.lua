return {
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<LEADER>gg", vim.cmd.Git)

			local myFugitive = vim.api.nvim_create_augroup("myFugitive", {})
			vim.api.nvim_create_autocmd(
				"BufWinEnter", {
					group = myFugitive,
					pattern = "*",
					callback = function()
						if vim.bo.ft ~= "fugitive" then
							return
						end

						local bufnr = vim.api.nvim_get_current_buf()
						local opts = { buffer = bufnr, remap = false }

						vim.keymap.set(
							"n", "<LEADER>gP", function()
								vim.cmd.Git("push")
							end, opts
						)

						-- Push with rebase
						-- vim.keymap.set(
						-- 	"n", "<LEADER>gp", function()
						-- 		vim.cmd.Git({ "push", "--rebase" })
						-- 	end, opts
						-- )
					end,
				}
			)
		end
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function _map(mode, l, r, desc)
					vim.keymap.set(mode, l ,r, { buffer = bufnr, desc = desc })
				end

				-- Navigation between hunks
				_map("n", "]h", gs.next_hunk, "Move to next hunk")
				_map("n", "[h", gs.prev_hunk, "Move to previous hunk")

				-- Git actions
				_map("n", "<LEADER>gs", gs.stage_hunk, "Stage hunk lines under cursor")
				_map("n", "<LEADER>gr", gs.reset_hunk, "Reset hunk lines under cursor")
				_map(
					"v", "<LEADER>gs", function()
						gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, "Stage visually selected hunk"
				)
				_map(
					"v", "<LEADER>gr", function()
						gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, "Reset visually selected hunk"
				)

				_map("n", "<LEADER>gS", gs.stage_buffer, "Stage entire buffer")
				_map(
					"n", "<LEADER>gR", function()
						local _confirm = vim.fn.confirm("Reset entire buffer?", "&yes\n&no", 2)
						if _confirm == 1 then
							gs.reset_buffer()
						end
					end, "Reset entire buffer"
				)
				_map("n", "<LEADER>gu", gs.undo_stage_hunk, "Undo stage hunk (not reset file)")
				_map("n", "<LEADER>gp", gs.preview_hunk, "Preview hunk info")
				_map(
					"n", "<LEADER>gb", function()
						gs.blame_line({ full = true })
					end, "Check git blame line"
				)
				_map("n", "<LEADER>gB", gs.toggle_current_line_blame, "Toggle line blame")
				_map("n", "<LEADER>gd", gs.diffthis, "Diff this")
				_map(
					"n", "<LEADER>gD", function()
						gs.diffthis("~")
					end, "Diff this ~"
				)

				_map(
					{ "o", "x" }, "<LEADER>gv",
					":<C-U>Gitsigns select_hunk<CR>", "Select hunk"
				)
			end
		},
	},
	{
		"ThePrimeagen/git-worktree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim"
		},
		config = function()
			local gitWorkTree = require("git-worktree")
			gitWorkTree.setup()

			local tele = require("telescope")

			tele.load_extension("git_worktree")

			-- Keymaps
			-- List worktree
			vim.keymap.set(
				"n", "<LEADER>gt", function()
					tele.extensions.git_worktree.git_worktrees()
				end, { desc = "List git worktrees" }
			)

			vim.keymap.set(
				"n", "<LEADER>gc", function()
					tele.extensions.git_worktree.create_git_worktree()
				end, { desc = "Create git worktree branch" }
			)
		end,
	},
}

