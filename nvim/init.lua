-- Leader
vim.g.mapleader = "\\"

-- Configuration
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gy", vim.lsp.buf.type_definition)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)
vim.keymap.set("n", "g]", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>ac", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>nt", ":Neotree toggle<CR>")
vim.keymap.set("n", "<leader>nf", ":Neotree focus<CR>")

vim.keymap.set("n", "<c-t>", [[<Cmd>exe v:count1 . "ToggleTerm"<CR>]], { noremap = true })
vim.cmd([[command! -nargs=? Fold :lua vim.lsp.buf.fold() <f-args>]])
vim.cmd([[command! -nargs=? Format :lua vim.lsp.buf.format() <f-args>]])

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.list = true
vim.o.listchars = [[tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%]]

require("config.lazy")
