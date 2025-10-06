return {
	-- Mini Toolkit for Neovim
	{ "echasnovski/mini.nvim", version = false },

	-- Mini Comment
	{
		"echasnovski/mini.comment",
		version = false,
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			require("ts_context_commentstring").setup {
				enable_autocmd = false,
			}
			require("mini.comment").setup {
				-- tsx, jsx, html comment support
				options = {
					custom_commentstring = function()
						return require("ts_context_commentstring.internal")
							.calculate_commentstring({
								key = "commentstring"
							}) or vim.bo.commentstring
					end,
				},
			}
		end
	},

	-- Mini surround: change surround of a string
	{
		"echasnovski/mini.surround",
		event = { "BufReadPre", "BufNewFile" },
		-- sa: Add surround in n / v
		-- sd: Delete surround
		-- sf: Find surround and to the right end
		-- sF: Find surround and to the left end
		-- sh: Highlight surround
		-- sr: Replace surround
		opts = {
			mappings = {
				add = "<LEADER>ma",
				delete = "<LEADER>md",
				find = "<LEADER>mf",
				find_left = "<LEADER>mF",
				highlight = "<LEADER>mh",
				replace = "<LEADER>mr",
			},
		}
	},

	-- Mini Trailspace: Auto Erase whitespace
	{
		"echasnovski/mini.surround",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local miniTrailSpace = require("mini.trailspace")
			miniTrailSpace.setup({
				only_in_normal_buffers = true,
			})

			-- Keymaps
			vim.keymap.set(
				"n", "<LEADER>cw", function()
					miniTrailSpace.trim()
				end, { desc = "Erase whitespace" }
			)

			-- Disable whitespace highlight remind
--			vim.api.nvim_create_autocmd(
--				"CursorMoved", {
--					pattern = "*",
--					callback = function()
--						miniTrailSpace.unhighlight()
--					end,
--				}
--			)
		end
	},

	-- Mini Split-Join: Auto split into multi-lines / join into one line
	{
		"echasnovski/mini.splitjoin",
		config = function()
			local miniSplitJoin = require("mini.splitjoin")

			miniSplitJoin.setup({
				mappings = {
					toggle = "",  -- Disable default
				}
			})

			vim.keymap.set(
				{ "n", "x" }, "<LEADER>mj", function()
					miniSplitJoin.join()
				end, { desc = "Join arguments" }
			)

			vim.keymap.set(
				{ "n", "x" }, "<LEADER>ms", function()
					miniSplitJoin.split()
				end, { desc = "Split arguments" }
			)
		end
	},
}
