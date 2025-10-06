return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		-- LSP key binds
		vim.api.nvim_create_autocmd(
			"LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Buffer local mappings
					local opts = { buffer = ev.buf, silent = true }

					opts.desc = "Show LSP references"
					vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

					opts.desc = "Go to declaration"
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

					opts.desc = "Show LSP definitions"
					vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

					opts.desc = "Show LSP implementations"
					vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

					opts.desc = "Show LSP type definitions"
					vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

					opts.desc = "See available code actions"
					vim.keymap.set(
						{ "n", "v" }, "<LEADER>vca", function()
							vim.lsp.buf.code_action()
						end, opts
					)

					opts.desc = "Smart rename"
					vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts)

					opts.desc = "Show buffer diagnostics"
					vim.keymap.set("n", "gL", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

					opts.desc = "Show line diagnostics"
					vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)

					opts.desc = "Show documentations"
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

					opts.desc = "Show symbol signature help"
					vim.keymap.set(
						"i", "<C-h>", function()
							vim.lsp.buf.signature_help()
						end, opts
					)
				end,
			}
		)

		-- Severity Sign Icons
		local signs = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = "󰠠 ",
			[vim.diagnostic.severity.INFO] = " ",
		}

		vim.diagnostic.config({
			signs = {
				text = signs,
			},
			virtual_text = true,
			underline = true,
			update_in_insert = false,
		})

		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Global default LSP settings
		vim.lsp.config('*', {
			capabilities = capabilities,
		})

		-- Enable each LSP
		-- lua_ls (lua-language-server binary needed in $PATH)
		vim.lsp.config(
			"lua_ls", {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						completion = {
							callSnippet = "Replace",
						},
						workspace = {
							library = {
								[vim.fn.expand('$VIMRUNTIME/lua')] = true,
								[vim.fn.stdpath("config") .. "/lua"] = true,
							},
						},
					},
				},
			}
		)
		vim.lsp.enable("lua_ls")

		-- gopls
		vim.lsp.config(
			"gopls", {
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
						},
						staticcheck = true,
						gofumpt = true,
					},
				},
			}
		)
		vim.lsp.enable("gopls")

		-- pylsp
		-- https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
		vim.lsp.config(
			"pylsp", {
				settings = {
					pylsp = {
						configurationSources = { "flake8" },
						plugins = {
							pycodestyle = {
								enable = false,
							},
							mccabe = {
								enable = false,
							},
							pyflakes = {
								enable = false,
							},
							flake8 = {
								enable = true,
								executable = "flake8",  -- Use system package
								indentSize = 4,
							},
						},
					},
				},
			}
		)
		vim.lsp.enable("pylsp")

		-- rust-analyzer
		-- https://rust-analyzer.github.io/book/configuration.html
		vim.lsp.enable('rust_analyzer')

		-- java_language_server
		-- https://github.com/georgewfraser/java-language-server
		vim.lsp.enable('java_language_server')

		-- clangd
		vim.lsp.enable("clangd")

		-- fish_lsp
		vim.lsp.enable('fish_lsp')
	end,
}
