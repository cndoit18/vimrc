return {
	"rest-nvim/rest.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	ft = { "http" },
	config = function()
		require("telescope").load_extension("rest")
		require("rest-nvim").setup()
	end,
}
