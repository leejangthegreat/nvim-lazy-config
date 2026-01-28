local _default_km_opts = { noremap = true, silent = true }

local function _make_opts(overrides)
	return vim.tbl_extend("force", _default_km_opts, overrides or {})
end



vim.g.mapleader = " "
vim.g.maplocalleader = " "


vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move choosen lines down in visual line mode" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move choosen lines up in visual line mode" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Merge current line with the line below" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move down in buffer with cursor centred" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move up in buffer with cursor centred" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Jump to next search result with cursor centred" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Jump to previous search result with cursor centred" })

vim.keymap.set("v", "<", "<gv", _make_opts({ desc = "Decrease line indentation" }))
vim.keymap.set("v", ">", ">gv", _make_opts({ desc = "Increase line indentation" }))


-- CLIPBOARD Setting
-- Paste without replacing clipboard content
vim.keymap.set("x", "<LEADER>P", '[["_dP]]', _make_opts({ desc = "Paste without replacing clipboard content" }))
vim.keymap.set("v", "<LEADER>P", '"_dP', _make_opts({ desc = "Paste without replacing clipboard in VL mode" }))

-- Delete without copy
vim.keymap.set({ "n", "v" }, "<LEADER>d", '[["_d]]', _make_opts({ desc = "Delete without copy" }))
vim.keymap.set("n", "x", '"_x', _make_opts({ desc = "Delete character without copy" }))

-- Highlight yank text
vim.api.nvim_create_autocmd(
	"TextYankPost",
	{
		desc = "Highlight yanked text",
		group = vim.api.nvim_create_augroup(
			"kickstart-highlight-yank", { clear = true }
		),
		callback = function()
			vim.highlight.on_yank()
		end,
	}
)


-- Search and Edit Setting
vim.keymap.set("i", "<C-c>", "<Esc>", _make_opts({ desc = "Exit insert mode with <C-c>" }))
vim.keymap.set("n", "<C-c>", ":nohl<CR>", _make_opts({ desc = "Clear search highlights", silent = true }))
vim.keymap.set("n", "<LEADER>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word on cursor globally" })

-- Formatting
vim.keymap.set("n", "<LEADER>f", vim.lsp.buf.format, _make_opts({ desc = "Format code" }))
vim.keymap.set("n", "<LEADER>x", "<cmd>!chmod +x %<CR>", _make_opts({ desc = "Make current file executable" }))


-- Disable Original Command Line
vim.keymap.set("n", "Q", "<nop>")


-- TAB Control Setting
vim.keymap.set("n", "<LEADER>to", "<cmd>tabnew<CR>", _make_opts({ desc = "Open new tab" }))
vim.keymap.set("n", "<LEADER>tx", "<cmd>tabclose<CR>", _make_opts({ desc = "Close current tab" }))
vim.keymap.set("n", "<LEADER>tn", "<cmd>tabn<CR>", _make_opts({ desc = "Goto next tab" }))
vim.keymap.set("n", "<LEADER>tp", "<cmd>tabp<CR>", _make_opts({ desc = "Goto previous tab" }))


-- Window Control Setting
vim.keymap.set("n", "<LEADER>wv", "<C-w>v", _make_opts({ desc = "Split window vertically" }))
vim.keymap.set("n", "<LEADER>ws", "<C-w>s", _make_opts({ desc = "Split window horizontally" }))
vim.keymap.set("n", "<LEADER>we", "<C-w>=", _make_opts({ desc = "Make all windows equally" }))
vim.keymap.set("n", "<LEADER>wx", "<cmd>close<CR>", _make_opts({ desc = "Close current split" }))
vim.keymap.set("n", "<LEADER>wh", "<C-w>h", _make_opts({ desc = "Move to left window split" }))
vim.keymap.set("n", "<LEADER>wl", "<C-w>l", _make_opts({ desc = "Move to right window split" }))
vim.keymap.set("n", "<LEADER>wj", "<C-w>j", _make_opts({ desc = "Move to window split below" }))
vim.keymap.set("n", "<LEADER>wk", "<C-w>k", _make_opts({ desc = "Move to window split above" }))

-- Terminal Control Setting
-- Terminal Mode
vim.keymap.set("n", "<LEADER>co", "<cmd>terminal<CR>", _make_opts({ desc = "Open terminal buffer in cwd" }))
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", _make_opts({ desc = "Exit terminal editing" }))

-- View single cmd result
vim.api.nvim_create_user_command("RunShellCommand", function(opts)
	local output = vim.fn.systemlist(opts.args)

	vim.cmd("new")
	local _buf = vim.api.nvim_get_current_buf()
	vim.bo[_buf].buftype = 'nofile'
	vim.bo[_buf].bufhidden = 'wipe'
	vim.bo[_buf].swapfile = false

	-- Write command result
	vim.api.nvim_buf_set_lines(_buf, 0, -1, false, output)

	-- Set Buf to readonly after record result
	vim.bo[_buf].modifiable = false
	vim.bo[_buf].readonly = true
end, { nargs = "+", complete = "shellcmd", desc = "Run shell command and display result in new buf" })

-- File Control Setting
vim.keymap.set(
	"n", "<LEADER>fp", function()
		local sFilePath = vim.fn.expand("%:~")
		vim.fn.setreg("+", sFilePath)  -- Copy to clip register
	end, _make_opts({ desc = "Copy current filepath to clipboard" })
)
