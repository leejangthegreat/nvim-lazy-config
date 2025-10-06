return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons"
	},
	config = function()
		local luaLine = require("lualine")
		local lazyStatus = require("lazy.status")  -- Configure lazy pending updates count

		-- Colors for different mode can be set here


		-- Components
		-- Mode indicators
--		local mode = {
--			'mode', fmt = function(str)
--				return " " .. str
--			end,
--		}

		local mode = {
			'mode', fmt = function(str)
				return str
			end,
		}

		local diff = {
			'diff',
			colored = true,
			symbols = {
				added = ' ', modified = ' ', removed = ' '
			}
		}

		local filename = {
			'filename',
			file_status = true,
			path = 0,  -- Just show filename
		}

		local branch = {
			'branch',
			icon = { "", color = { fg = "#A6D4DE" } },
			'|'
		}

		luaLine.setup({
			icons_enabled = true,
			options = {
				theme=my_lualine_theme,
				component_separators = { left = '|', right = '|' },
				section_separators = { left = '', right = '' }
			},
			sections = {
				lualine_a = { mode },
				lualine_b = { filename },
				lualine_c = { branch, diff },
				lualine_x = {
					{
						lazyStatus.updates,
						cond = lazyStatus.has_updates,
						color = { fg = "#FF9E64" },
					},
					{ "filetype" },
				},
			},
		})
	end
}
