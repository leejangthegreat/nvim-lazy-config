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
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight yanked text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Search and Edit Setting
vim.keymap.set("i", "<C-c>", "<Esc>", _make_opts({ desc = "Exit insert mode with <C-c>" }))
vim.keymap.set("n", "<C-c>", ":nohl<CR>", _make_opts({ desc = "Clear search highlights", silent = true }))
vim.keymap.set(
	"n",
	"<LEADER>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word on cursor globally" }
)

-- Formatting
vim.keymap.set({ "n", "v" }, "<LEADER>fc", vim.lsp.buf.format, _make_opts({ desc = "Format code" }))
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
vim.keymap.set("n", "<LEADER>wt", "<C-w>T", _make_opts({ desc = "Move current buffer to new tab" }))

-- Terminal Control Setting
-- Terminal Mode
vim.keymap.set("n", "<LEADER>co", "<cmd>terminal<CR>", _make_opts({ desc = "Open terminal buffer in cwd" }))
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", _make_opts({ desc = "Exit terminal editing" }))

-- View single cmd result
vim.api.nvim_create_user_command("RunShellCommand", function(opts)
	local output = vim.fn.systemlist(opts.args)

	vim.cmd("new")
	local _buf = vim.api.nvim_get_current_buf()
	vim.bo[_buf].buftype = "nofile"
	vim.bo[_buf].bufhidden = "wipe"
	vim.bo[_buf].swapfile = false

	-- Write command result
	vim.api.nvim_buf_set_lines(_buf, 0, -1, false, output)

	-- Set Buf to readonly after record result
	vim.bo[_buf].modifiable = false
	vim.bo[_buf].readonly = true
end, { nargs = "+", complete = "shellcmd", desc = "Run shell command and display result in new buf" })

-- File Control Setting
vim.keymap.set("n", "<LEADER>fp", function()
	local sFilePath = vim.fn.expand("%:~")
	vim.fn.setreg("+", sFilePath) -- Copy to clip register
end, _make_opts({ desc = "Copy current filepath to clipboard" }))

local function jq_format_current_buffer(opts)
	local bufnr = vim.api.nvim_get_current_buf()

	if not vim.api.nvim_buf_is_valid(bufnr) then
		vim.notify("JqFormat: invalid buffer", vim.log.levels.WARN)
		return
	end

	if vim.bo[bufnr].buftype ~= "" then
		vim.notify("JqFormat: not a normal file buffer", vim.log.levels.WARN)
		return
	end

	if not vim.bo[bufnr].modifiable then
		vim.notify("JqFormat: buffer is not modifiable", vim.log.levels.WARN)
		return
	end

	local ft = vim.bo[bufnr].filetype
	local is_jsonl = ft == "jsonl"
	if ft ~= "json" and not is_jsonl then
		vim.notify("JqFormat: unsupported filetype '" .. ft .. "', expected json or jsonl", vim.log.levels.WARN)
		return
	end

	if vim.fn.executable("jq") == 0 then
		vim.notify("JqFormat: jq not found in PATH", vim.log.levels.ERROR)
		return
	end

	local indent = 4
	if opts.args and opts.args ~= "" then
		local n = tonumber(opts.args)
		if not n then
			vim.notify("JqFormat: indent must be a number, got: " .. opts.args, vim.log.levels.ERROR)
			return
		end
		if n ~= math.floor(n) then
			vim.notify("JqFormat: indent must be an integer, got: " .. opts.args, vim.log.levels.ERROR)
			return
		end
		if n < 0 or n > 7 then
			-- JQ support indent no more than 7
			vim.notify("JqFormat: indent must be between 0 and 7, got: " .. opts.args, vim.log.levels.ERROR)
			return
		end
		indent = n
	end

	local view = vim.fn.winsaveview()
	local changedtick = vim.b[bufnr].changedtick
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	-- Check if file is empty
	if #lines == 0 or (#lines == 1 and lines[1] == "") then
		vim.notify("JqFormat: buffer is empty, nothing to format", vim.log.levels.INFO)
		return
	end

	-- Re-construct file content from lines
	local input
	if #lines == 1 and lines[1]:sub(-1) ~= "\n" then
		input = lines[1] .. "\n"
	else
		input = table.concat(lines, "\n") .. "\n"
	end

	local jq_args = { "jq" }
	if is_jsonl then
		-- -c will override indent setting
		table.insert(jq_args, "-c")
	else
		table.insert(jq_args, "--indent")
		table.insert(jq_args, tostring(indent))
	end
	table.insert(jq_args, ".")

	vim.system(jq_args, { text = true, stdin = input }, function(res)
		vim.schedule(function()
			if not vim.api.nvim_buf_is_valid(bufnr) then
				return
			end

			if vim.b[bufnr].changedtick ~= changedtick then
				vim.notify("JqFormat: buffer changed during formatting, aborting", vim.log.levels.WARN)
				return
			end

			if res.code ~= 0 then
				local msg = (res.stderr and res.stderr ~= "") and res.stderr
					or ("jq failed, exit code " .. tostring(res.code))
				local name = vim.api.nvim_buf_get_name(bufnr)
				vim.notify("JqFormat: " .. msg .. " (" .. name .. ")", vim.log.levels.ERROR)
				return
			end

			if res.stdout == nil or res.stdout == "" then
				vim.notify("JqFormat: jq produced no output", vim.log.levels.WARN)
				return
			end

			local out_lines = vim.split(res.stdout, "\n", { plain = true })
			if #out_lines > 0 and out_lines[#out_lines] == "" then
				table.remove(out_lines, #out_lines)
			end

			vim.cmd("silent! undojoin")
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, out_lines)
			vim.fn.winrestview(view)

			local name = vim.api.nvim_buf_get_name(bufnr)
			vim.notify("JqFormat: formatted " .. name .. " (indent=" .. indent .. ")", vim.log.levels.INFO)
		end)
	end)
end

vim.api.nvim_create_user_command("JqFormat", jq_format_current_buffer, {
	nargs = "?",
	desc = "Format current buffer as JSON/JSONL using jq (optional indent 0-7, default 4); keep buffer on error",
})
