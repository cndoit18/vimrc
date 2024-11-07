return {
	"mhartington/formatter.nvim",
	lazy = false,
	config = function()
		local prettier = require("formatter.defaults").prettier
		require("formatter").setup({
			-- Enable or disable logging
			logging = true,
			-- Set the log level
			log_level = vim.log.levels.WARN,
			-- All formatter configurations are opt-in
			filetype = {
				lua = { require("formatter.filetypes.lua").stylua },
				sql = { require("formatter.filetypes.sql").sqlfmt },
				sh = { require("formatter.filetypes.sh").shfmt },
				python = { require("formatter.filetypes.python").ruff },
				go = { require("formatter.filetypes.go").gofumpt },
				rust = { require("formatter.filetypes.rust").rustfmt },

				glsl = { prettier }, -- to work install prettier-plugin-glsl and add it to the prettier config: `plugins: ["prettier-plugin-glsl"]`
				svelte = { prettier },
				javascript = { prettier },
				javascriptreact = { prettier },
				typescript = { prettier },
				typescriptreact = { prettier },
				astro = { prettier }, -- prettier-plugin-astro
				vue = { prettier },
				css = { prettier },
				scss = { prettier },
				less = { prettier },
				html = { prettier },
				json = { prettier },
				jsonc = { prettier },
				yaml = { prettier },
				markdown = { prettier },
				graphql = { prettier },
				handlebars = { prettier },
				svg = { prettier },

				["*"] = {
					require("formatter.filetypes.any").remove_trailing_whitespace,
				},
			},
		})

		local format_augroup = vim.api.nvim_create_augroup("formatter", { clear = true })
		vim.api.nvim_create_autocmd({
			"BufWritePost",
		}, {
			group = format_augroup,
			command = ":FormatWrite",
		})
	end,
}
