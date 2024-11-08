return {
	"akinsho/toggleterm.nvim",
	dependencies = {
		"nvim-lualine/lualine.nvim",
	},
	version = "*",
	cmd = {
		"ToggleTerm",
	},
	opts = {
		start_in_insert = true,
		on_open = function(term)
			vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
		end,
	},
	keys = {
		{ "<leader><C-t>", [[<cmd>exe v:count1 "ToggleTerm"<CR>]], { buffer = 0 }, desc = "Toggle Terminal" },
	},
	init = function()
		table.insert(require("lualine").get_config().extensions, "toggleterm")
	end,
}
