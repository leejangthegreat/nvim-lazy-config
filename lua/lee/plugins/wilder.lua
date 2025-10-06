return {
	-- Improve neovim command completion
	"gelguy/wilder.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"romgrk/fzy-lua-native",
	},
	config = function()
		local wilder = require('wilder')
		wilder.setup({ modes = { ':', '/', '?' } })

		-- Custom highlight groups
		wilder.set_option(
			"renderer", wilder.popupmenu_renderer(
				wilder.popupmenu_border_theme({
					min_width = "20%",
					max_height = "15%",
					reverse = 1,
					highlighter = {
						wilder.lua_fzy_highlighter(),  -- fzy-lua-native needed
					},
					highlights = {
						default = wilder.make_hl(
							"WIlderPopupMenu", "Pmenu", {
								{ a = 1 },
								{ a = 1 },
								{ background = "#1E212B" }
							}
						),
						accent = wilder.make_hl(
							"WilderAccent", "Pmenu", {
								{ a = 1 },
								{ a = 1 },
								{ foreground = "#58FFD6", background = "#1E1E2E" },
							}
						),
					},
					border = "single",  -- single / double / rounded / solid
				})
			)
		)
	end
}
