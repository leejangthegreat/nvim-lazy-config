vim.cmd("let g:netrw_banner = 0") -- Use a custom explorer
vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.updatetime = 50

--[[ TAB Behaviours --]]
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.autoindent = true
vim.opt.smartindent = true

--[[ Backspace Behavior --]]
vim.opt.backspace = { "start", "eol", "indent" }

--[[ Line Control --]]
vim.opt.cursorline = true
vim.opt.colorcolumn = "80"
vim.opt.wrap = true
vim.opt.linebreak = true -- Wrap not to break word
vim.opt.breakindent = true

--[[ TMP Files --]]
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true


--[[ Command Behaviors --]]
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard:append("unnamedplus") -- Use system clipboard directly

vim.opt.inccommand = "split"

--[[ GUI Behaviors --]]
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.scrolloff = 1 -- May cursor not scroll to edge
vim.opt.signcolumn = "yes" -- Enable sign beside col numbers

--[[ Mouse Behavior --]]
vim.opt.mouse = "n"

--[[ Window Behavior --]]
vim.opt.splitright = true
vim.opt.splitbelow = true

--[[ Editor Config --]]
vim.g.editorconfig = true

--[[ Python Config --]]
vim.g.python3_host_prog = vim.fn.expand("$HOME") .. "/.local/share/nvim/python3-venv/bin/python3"
