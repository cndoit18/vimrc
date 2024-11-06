local tools = {
	-- Formatter
	"delve",
	"stylua",
	"sqlfmt",
	"shfmt",
	"gofumpt",
	"prettier",

	-- Lint
	"markdownlint",
	"golangci-lint",

	-- All
	"ruff",
}

local lsp_servers = {
	"rust_analyzer",
	"bashls",
	"dockerls",
	"jsonls",
	"gopls",
	"helm_ls",
	"pyright",
	"lua_ls",
	"yamlls",
}

return {
	{
		"rcarriga/nvim-notify",
	},

	{
		"mfussenegger/nvim-dap",
		lazy = true,
		keys = {
			{ "<leader>d", "", desc = "+Debug" },
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Continue",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into",
			},
			{
				"<leader>dn",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
			},
			{
				"<leader>do",
				function()
					require("dap").step_out()
				end,
				desc = "Step Out",
			},
			{
				"<leader>du",
				function()
					require("dap").up()
				end,
				desc = "Up",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.toggle()
				end,
				desc = "Toggle REPL",
			},
			{
				"<leader>ds",
				function()
					require("dap").continue()
				end,
				desc = "Run",
			},
			{
				"<leader>dC",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Run to Cursor",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "Run Last",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
			{
				"<leader>dK",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "Widgets",
			},
		},
		config = function()
			local dap = require("dap")
			-- Go
			-- Requires:
			-- * You have initialized your module with 'go mod init module_name'.
			-- * You :cd your project before running DAP.
			dap.adapters.delve = {
				type = "server",
				port = "${port}",
				executable = {
					command = vim.fn.stdpath("data") .. "/mason/packages/delve/dlv",
					args = { "dap", "-l", "127.0.0.1:${port}" },
				},
			}
			dap.configurations.go = {
				{
					type = "delve",
					name = "Compile module and debug this file",
					request = "launch",
					program = "./${relativeFileDirname}",
				},
				{
					type = "delve",
					name = "Compile module and debug this file (test)",
					request = "launch",
					mode = "test",
					program = "./${relativeFileDirname}",
				},
			}
		end,
		dependencies = {
			{
				"rcarriga/nvim-dap-ui",
				dependencies = "nvim-neotest/nvim-nio",
				keys = {
					{
						"<leader>du",
						function()
							require("dapui").toggle({})
						end,
						desc = "Dap UI",
					},
					{
						"<leader>dE",
						function()
							require("dapui").eval()
						end,
						desc = "Eval",
						mode = { "n", "v" },
					},
				},
				config = function(_, opts)
					local dap, dapui = require("dap"), require("dapui")
					dapui.setup(opts)
					dap.listeners.after.event_initialized["dapui_config"] = function()
						dapui.open({})
					end
					dap.listeners.before.event_terminated["dapui_config"] = function()
						dapui.close({})
					end
					dap.listeners.before.event_exited["dapui_config"] = function()
						dapui.close({})
					end

					local dap_breakpoint = {
						error = {
							text = "🟥",
							texthl = "LspDiagnosticsSignError",
							linehl = "",
							numhl = "",
						},
						rejected = {
							text = "",
							texthl = "LspDiagnosticsSignHint",
							linehl = "",
							numhl = "",
						},
						stopped = {
							text = "⭐️",
							texthl = "LspDiagnosticsSignInformation",
							linehl = "DiagnosticUnderlineInfo",
							numhl = "LspDiagnosticsSignInformation",
						},
					}

					vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
					vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
					vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)
				end,
			},
		},
	},

	{
		"folke/trouble.nvim",
		cmd = { "Trouble" },
		init = function()
			vim.diagnostic.config({ virtual_text = false })
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
	},

	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {
			modes = {
				char = {
					jump_labels = true,
				},
				search = {
					enabled = false,
				},
			},
		},
	},

	{
		"williamboman/mason.nvim",
		lazy = false,
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			module = "mason",
		},
		config = function()
			require("mason").setup()
			local registry = require("mason-registry")
			local function install_ensured()
				for _, tool in ipairs(tools) do
					local p = registry.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end
			if registry.refresh then
				registry.refresh(install_ensured)
			else
				install_ensured()
			end
			require("mason-lspconfig").setup({ ensure_installed = lsp_servers })
		end,
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		lazy = false,
		branch = "v3.x",
		cmd = "Neotree",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
			{
				"s1n7ax/nvim-window-picker",
				lazy = true,
				opts = {
					filter_rules = {
						-- filter using buffer options
						bo = {
							-- if the file type is one of following, the window will be ignored
							filetype = {
								"neo-tree",
								"neo-tree-popup",
								"notify",
								"packer",
								"qf",
								"diff",
								"fugitive",
								"fugitiveblame",
							},

							-- if the buffer type is one of following, the window will be ignored
							buftype = { "nofile", "help", "terminal" },
						},
					},
				},
			},
		},
		opts = {
			event_handlers = {
				{
					event = "neo_tree_buffer_enter",
					handler = function()
						vim.cmd([[setlocal relativenumber]])
					end,
				},
			},
			close_if_last_window = true,
			filesystem = {
				commands = {
					delete = function(state)
						local path = state.tree:get_node().path
						vim.fn.system({ "trash", vim.fn.fnameescape(path) })
						require("neo-tree.sources.manager").refresh(state.name)
					end,
					system_open = function(state)
						local node = state.tree:get_node()
						local path = node:get_id()
						local getOS = function()
							local handle = io.popen("uname -s")
							if handle == nil then
								vim.notify("Error while opening handler", vim.log.levels.ERROR)
								return ""
							end
							local uname = handle:read("*a")
							handle:close()
							uname = uname:gsub("%s+", "")
							if uname == "Darwin" then
								return "Darwin"
							elseif uname == "NixOS" then
								return "NixOS"
							elseif uname == "Linux" then
								return "Linux"
							else
								return ""
							end
						end
						if getOS() == "Darwin" then
							vim.api.nvim_command("silent !open -g " .. path)
						elseif getOS() == "Linux" then
							vim.api.nvim_command(string.format("silent !xdg-open '%s'", path))
						else
							vim.notify("Could not determine OS", vim.log.levels.ERROR)
						end
					end,
				},
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
				},
				follow_current_file = {
					enabled = true,
				},
			},
			window = { mappings = {
				["<2-LeftMouse>"] = "system_open",
			} },
		},
		config = function(_, opts)
			require("neo-tree").setup(opts)
			vim.api.nvim_create_autocmd("TermClose", {
				pattern = "*lazygit",
				callback = function()
					if package.loaded["neo-tree.sources.git_status"] then
						require("neo-tree.sources.git_status").refresh()
					end
				end,
			})
		end,
	},

	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				markdown = { "markdownlint" },
				go = { "golangcilint" },
				rust = { "clippy" },
				python = { "ruff" },
			}
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},

	{
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
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			theme = "gruvbox-material",
		},
		config = function(_, opts)
			require("lualine").setup({
				options = opts,
				extensions = { "neo-tree", "lazy" },
			})
		end,
	},

	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},

	{ "Bilal2453/luvit-meta", lazy = true },

	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"nvim-lualine/lualine.nvim",
		},
		opts = {
			current_line_blame = true,
		},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"cmake",
					"css",
					"dockerfile",
					"go",
					"html",
					"java",
					"javascript",
					"json",
					"jsonc",
					"lua",
					"markdown",
					"markdown_inline",
					"python",
					"regex",
					"toml",
					"vim",
					"yaml",
					"rust",
				},
				highlight = {
					enable = true,
				},
				endwise = {
					enable = true,
				},
				indent = { enable = true },
				autopairs = { enable = true },
			})
		end,
	},

	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			open_mapping = [[<C-t>]],
			terminal_mappings = true,
			start_in_insert = true,
		},
		config = function(_, opts)
			require("toggleterm").setup({
				options = opts,
			})
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				mapping = {
					["<C-y>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.confirm({
								select = true,
							})
						else
							fallback()
						end
					end),

					["<C-n>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<C-p>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),
				},

				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{
						name = "lazydev",
						group_index = 0, -- set group index to 0 to skip loading LuaLS completions
					},
				},
			})
			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
				---@diagnostic disable-next-line: missing-fields
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			local lspconfig = require("lspconfig")
			local util = require("lspconfig/util")

			local path = util.path

			local function get_python_path(workspace)
				-- Use activated virtualenv.
				if vim.env.VIRTUAL_ENV then
					return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
				end

				-- Find and use virtualenv in workspace directory.
				for _, pattern in ipairs({ "*", ".*" }) do
					local match = vim.fn.glob(path.join(workspace, pattern, "pyvenv.cfg"))
					if match ~= "" then
						return path.join(path.dirname(match), "bin", "python")
					end
				end

				-- Fallback to system Python.
				return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
			end

			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}
			for _, lsp in ipairs(lsp_servers) do
				lspconfig[lsp].setup({
					before_init = function(_, config)
						if lsp == "pyright" then
							config.settings.python.pythonPath = get_python_path(config.root_dir)
						end
					end,
					capabilities = capabilities,
				})
			end
		end,
	},

	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		init = function()
			vim.api.nvim_create_user_command("Rg", function(opts)
				require("fzf-lua").live_grep({ search = opts.args })
			end, {
				nargs = "?",
				desc = "Grep for text in files.",
			})
		end,
		config = function()
			-- calling `setup` is optional for customization
			require("fzf-lua").setup({})
		end,
	},

	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = "cd app && yarn install",
	},

	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
		},
		opts = {
			provider_selector = function(_, _, _)
				return { "treesitter", "indent" }
			end,
		},
		config = function(_, opts)
			vim.o.foldcolumn = "1" -- '0' is not bad
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			vim.keymap.set("n", "zR", require("ufo").openAllFolds)
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

			require("ufo").setup(opts)
		end,
	},

	{
		"kdheepak/lazygit.nvim",
		lazy = false,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
			-- + brew install jesseduffield/lazygit/lazygit
		},
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
		config = function()
			require("telescope").load_extension("lazygit")
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"debugloop/telescope-undo.nvim",
		},
		init = function()
			local undodir = vim.fn.stdpath("data") .. "/undodir"
			local handle = io.open(undodir)
			if handle then
				handle:close()
			else
				os.execute("mkdir -p " .. undodir)
			end
			vim.opt.undodir = undodir
			vim.opt.undofile = true
		end,
		config = function()
			require("telescope").setup({})
			require("telescope").load_extension("undo")
			-- optional: vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
		end,
	},
}
