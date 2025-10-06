local sLazyPath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(sLazyPath) then
	local sLazyRepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system(
		{
			"git",
			"clone",
			"--filter=blob:none",
			"--branch=stable",
			sLazyRepo,
			sLazyPath
		}
	)
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo(
			{
				{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
				{ out, "WarningMsg" },
				{ "\nPress any key to exit ..." },
			}, true, {}
		)
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(sLazyPath)

-- mapleader and maplocalleader must be set before !!!

require("lazy").setup(
	{
		{ import = "lee.plugins" },
		{ import = "lee.plugins.lsp" },
	},
	{
		checker = {
			enable = true,
			notify = false
		},
		change_detection = {
			notify = false
		},
	}
)
