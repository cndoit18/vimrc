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
	},
	keys = {
		{ "<leader><C-t>", [[<cmd>exe v:count1 "ToggleTerm"<CR>]], { buffer = 0 }, desc = "Toggle Terminal" },
		{ "<esc>", [[<C-\><C-n>]], mode = { "t" }, { buffer = 0 }, desc = "Exit Terminal" },
	},
	init = function()
		table.insert(require("lualine").get_config().extensions, "toggleterm")
	end,
}
