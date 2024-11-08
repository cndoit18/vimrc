return {
	"folke/trouble.nvim",
	dependencies = {
		"nvim-lualine/lualine.nvim",
	},
	cmd = { "Trouble" },
	init = function()
		vim.diagnostic.config({ virtual_text = false })
		table.insert(require("lualine").get_config().extensions, "trouble")

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
	end,
	opts = {
		auto_preview = false,
		modes = {
			preview_diagnostics = {
				mode = "diagnostics",
				preview = {
					type = "split",
					relative = "win",
					position = "right",
					size = 0.3,
				},
			},
		},
	},
	keys = {
		{ "[g", vim.diagnostic.goto_prev },
		{ "]g", vim.diagnostic.goto_next },
		{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
		{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
		{ "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
		{
			"<leader>cS",
			"<cmd>Trouble lsp toggle<cr>",
			desc = "LSP references/definitions/... (Trouble)",
		},
		{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
		{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
		{
			"[q",
			function()
				if require("trouble").is_open() then
					---@diagnostic disable-next-line: missing-parameter,missing-fields
					require("trouble").prev({ skip_groups = true, jump = true })
				else
					local ok, err = pcall(vim.cmd.cprev)
					if not ok then
						vim.notify(err, vim.log.levels.ERROR)
					end
				end
			end,
			desc = "Previous Trouble/Quickfix Item",
		},
		{
			"]q",
			function()
				if require("trouble").is_open() then
					---@diagnostic disable-next-line: missing-parameter,missing-fields
					require("trouble").next({ skip_groups = true, jump = true })
				else
					local ok, err = pcall(vim.cmd.cnext)
					if not ok then
						vim.notify(err, vim.log.levels.ERROR)
					end
				end
			end,
			desc = "Next Trouble/Quickfix Item",
		},
	},
}
