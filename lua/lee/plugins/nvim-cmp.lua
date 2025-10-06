return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	branch = "main",
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",  -- Replace major ver by latest!
			build = "make install_jsregexp"
		},
		"saadparwaiz1/cmp_luasnip", -- autocompletion
		"rafamadriz/friendly-snippets", -- snippets
		"nvim-treesitter/nvim-treesitter",
		"onsails/lspkind.nvim", -- vs-code pictograms (icons)
		"roobert/tailwindcss-colorizer-cmp.nvim",
	},
	config = function()
		local cmp = require("cmp")
		local has_luasnip, luasnip = pcall(require, "luasnip")
		local lspkind = require("lspkind")
		local colorizer = require("tailwindcss-colorizer-cmp").formatter

		local rhs = function(keys)
			return vim.api.nvim_replace_termcodes(keys, true, true, true)
		end

		local lsp_kinds = {
            Class = ' ',
            Color = ' ',
            Constant = ' ',
            Constructor = ' ',
            Enum = ' ',
            EnumMember = ' ',
            Event = ' ',
            Field = ' ',
            File = ' ',
            Folder = ' ',
            Function = ' ',
            Interface = ' ',
            Keyword = ' ',
            Method = ' ',
            Module = ' ',
            Operator = ' ',
            Property = ' ',
            Reference = ' ',
            Snippet = ' ',
            Struct = ' ',
            Text = ' ',
            TypeParameter = ' ',
            Unit = ' ',
            Value = ' ',
            Variable = ' ',
        }

		-- Custom helper
		local column = function()
			local _line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col
		end

		-- For luasnip
		local in_snippet = function()
			local session = require("luasnip.session")
			local node = session.current_nodes[vim.api.nvim_get_cursor_buf()]

			if not node then
				return false
			end

			local snippet = node.parent.snippet
			local snip_begin, snip_end = snippet.mark:pos_begin_end()
			local pos = vim.api.nvim_win_get_cursor(0)

			if pos[1] - 1 >= snip_begin[1] and pos[1] - 1 <= snip_end[1] then
				return true
			end

			return false
		end

		-- Detect whitespace / line start position
		local in_whitespace = function()
			local col = column()
			return col == 0 or vim.api.nvim_get_current_line():sub(col, col):match('%s')
		end

		local in_leading = function()
			local col = column()
			local line = vim.api.nvim_get_current_line()
			local prefix = line:sub(1, col)
			return prefix:find('^%s*$')
		end

		local shift_width = function()
			if vim.o.softtabstop <= 0 then
				return vim.fn.shiftwidth
			else
				return vim.o.softtabstop
			end
		end

		local smart_backspace = function(dedent)
			local keys = nil
			if vim.o.expandtab then
				if dedent then
					keys = rhs('<C-D>')
				else
					keys = rhs('<BS>')
				end
			else
				local col = column()
				local line = vim.api.nvim_get_current_line()
				local prefix = line:sub(1, col)
				if in_leading() then
					keys = rhs('<BS>')
				else
					local previous_char = prefix:sub(#prefix, #prefix)
					if previous_char ~= ' ' then
						keys = rhs('<BS>')
					else
						keys = rhs('<C-\\><C-o>:set expandtab<CR><BS><C-\\><C-o>:set noexpandtab<CR>')
					end
				end
			end

			vim.api.nvim_feedkeys(keys, 'nt', true)
		end

        local smart_tab = function(opts)
            local keys = nil
            if vim.o.expandtab then
                keys = '<Tab>' -- Neovim will insert spaces.
            else
                local col = column()
                local line = vim.api.nvim_get_current_line()
                local prefix = line:sub(1, col)
                local in_leading_indent = prefix:find('^%s*$')
                if in_leading_indent then
                    -- inserts a hard tab.
                    keys = '<Tab>'
                else
                    local sw = shift_width()
                    local previous_char = prefix:sub(#prefix, #prefix)
                    local previous_column = #prefix - #previous_char + 1
                    local current_column = vim.fn.virtcol({ vim.fn.line('.'), previous_column }) + 1
                    local remainder = (current_column - 1) % sw
                    local move = remainder == 0 and sw or sw - remainder
                    keys = (' '):rep(move)
                end
            end

            vim.api.nvim_feedkeys(rhs(keys), 'nt', true)
        end

		local select_next_item = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end

		local select_prev_item = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end

		local switch_docwin = function()
			if cmp.visible_docs() then
				cmp.close_docs()
			else
				cmp.open_docs()
			end
		end

		-- Local wrapper to implement suffix matching and in-word completion
		-- Ref: https://github.com/hrsh7th/nvim-cmp/issues/1716
		local confirm = function(entry)
			local behavior = cmp.ConfirmBehavior.Replace
			if entry then
				local completion_item = entry.completion_item
				local newText = ""
				if completion_item.textEdit then
					newText = completion_item.textEdit.newText
				elseif type(completion_item.insertText) == 'string'
					and completion_item.insertText ~= '' then
					newText = completion_item.insertText
				else
					newText = completion_item.word or completion_item.label or ''
				end

				-- Check how much diffs after cursor position after replaced?
				local diff_after = math.max(
					0, entry.replace_range['end'].character + 1
				) - entry.context.cursor.col

				-- If text going to be replaced after cursor NOT matches suffix
				-- Then insert but not replace
				if entry.context.cursor_after_line:sub(1, diff_after)
					~= newText:sub(-diff_after) then
					behavior = cmp.ConfirmBehavior.Insert
				end
			end
			cmp.confirm({ select = true, behavior = behavior })
		end

		-- VSCode style snippets
		require("luasnip.loaders.from_vscode").lazy_load()

		cmp.setup({
			experimental = {
				ghost_text = false
			},
			completion = {
				completeopt = "menu,menuone,noinsert",  -- No auto-insert with only one
			},

			window = {
				documentation = {
					border = {'╭', '─', '╮', '│', '╯', '─', '╰', '│'},
				},
				completion = {
					border = {'┌', '─', '┐', '│', '┘', '─', '└', '│'},
				},
			},

			-- Config to work with snippets
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},

			-- autocompletion sources
			sources = cmp.config.sources({
				{ name = "luasnip" },
				{ name = "lazydev" },
				{ name = "nvim_lsp" },
				{ name = "buffer" },  -- Words within buffer
				{ name = "path" },
				{ name = "tailwindcss-colorizer-cmp" },
			}),

			-- Customized Mappings
			mapping = cmp.mapping.preset.insert({
				['<C-e>'] = cmp.mapping.abort(),
				['<C-d>'] = cmp.mapping(function()
					switch_docwin()
				end, { 'i', 's' }),

				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-b>'] = cmp.mapping.scroll_docs(-4),

				['<C-j>'] = cmp.mapping(select_next_item),
				['<C-k>'] = cmp.mapping(select_prev_item),

				['<CR>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							local entry = cmp.get_selected_entry()
							confirm(entry)
						else
							fallback()
						end
					end, { "i", "s" }),

				['<S-Tab>'] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_prev_item()
							elseif has_luasnip and in_snippet() and luasnip.jumpable(-1) then
								luasnip.jump(-1)
							elseif in_leading() then
								smart_backspace(true)  -- Need dedent
							elseif in_whitespace() then
								smart_backspace()
							else
								fallback()
							end
						end, { "i", "s" }),
				['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							-- If there is only one entry then just apply
							local entries = cmp.get_entries()
							if #entries == 1 then
								confirm(entries[1])
							else
								cmp.select_next_item()
							end
						elseif has_luasnip and luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						elseif in_whitespace() then
							smart_tab()
						else
							cmp.complete()
						end
					end, { "i", "s" }),
			}),
			formatting = {
				format = function(entry, vim_item)
					-- Add custom icons
					vim_item.kind = string.format("%s %s", lsp_kinds[vim_item.kind] or '', vim_item.kind)

					-- Add menu text tag
					vim_item.menu = ({
						buffer = '[Context]',
						nvim_lsp = '[LSP]',
						luasnip = '[SNIP]',
						nvim_lua = '[LUA]',
						latex_symbols = '[LaTeX]',
					})[entry.source.name]

					-- lspkind and tailwind for additional formatting
					vim_item = lspkind.cmp_format({
						maxwidth = 25,
						ellipsis_char = '...',
					})(entry, vim_item)

					if entry.source.name == 'nvim_lsp' then
						vim_item = colorizer(entry, vim_item)
					end

					return vim_item
				end,
			},
		})
	end,
}
