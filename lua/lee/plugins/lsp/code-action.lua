return {
	 "nvimtools/none-ls.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function(_, _opts)
		local none_ls = require("null-ls")
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		none_ls.setup({
			sources = {
				none_ls.builtins.formatting.clang_format,
				none_ls.builtins.formatting.stylua,
				none_ls.builtins.formatting.ruff,
			},
			on_attach = function(client, bufnr)
				if client:supports_method("textDocument/formatting") then
					-- Clear existing auto-formatting on save
					vim.api.nvim_clear_autocmds({
						group = augroup,
						buffer = bufnr,
					})
					-- Create new LSPFormat on save
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ bufnr = bufnr })
						end,
					})
				end
			end,
		})
	end,
}
