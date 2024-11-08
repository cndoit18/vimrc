-- Leader
vim.g.mapleader = "\\"

-- Configuration
vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr><esc>", { noremap = true })

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.list = true
vim.o.listchars = [[tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%]]

require("config.lazy")
