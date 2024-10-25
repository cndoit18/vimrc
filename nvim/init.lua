-- Leader
vim.g.mapleader = "\\"

-- Configuration

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }

		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>ac", vim.lsp.buf.code_action, opts)
	end,
})

vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { noremap = true })

-- put quickfix window always to the bottom
local qfgroup = vim.api.nvim_create_augroup("changeQuickfix", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	group = qfgroup,
	command = "wincmd J",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	group = qfgroup,
	command = "setlocal wrap",
})

-- close quickfix menu after selecting choice
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "qf", "quickfix" },
	command = [[
	nnoremap <buffer> <CR> <CR>:cclose<CR>
        nnoremap <buffer> k <Up><CR><C-w>p
        nnoremap <buffer> j <Down><CR><C-w>p
    ]],
})

vim.keymap.set("n", "<leader>nt", ":Neotree toggle<CR>")
vim.keymap.set("n", "<leader>nf", ":Neotree focus<CR>")

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.list = true
vim.o.listchars = [[tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%]]

local augroup = vim.api.nvim_create_augroup("numbertoggle", {})

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
	pattern = "*",
	group = augroup,
	callback = function()
		if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
			vim.opt.relativenumber = true
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
	pattern = "*",
	group = augroup,
	callback = function()
		if vim.o.nu then
			vim.opt.relativenumber = false
			vim.cmd("redraw")
		end
	end,
})

require("config.lazy")
