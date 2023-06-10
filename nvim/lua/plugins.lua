local plugins = {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = true,
				no_bold = true,
			})
			vim.opt.termguicolors = true
			-- vim.cmd("colorscheme gruvbox-material")
			vim.cmd("colorscheme catppuccin-mocha")
		end,
		lazy = false,
	},
	{ 'savq/melange-nvim' },
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "VeryLazy",
		config = function()
			require("telescope").setup({
				pickers = {
					find_files = {
						hidden = true,
						theme = "ivy",
					},
				},
				defaults = {
					layout_strategy = "bottom_pane",
				},
				extensions = {
					fzf = {
						fuzzy = true,             -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					},
				},
			})
			require("telescope").load_extension("fzf")
		end,
		keys = {

			{ "<leader>ff", function()
				require('telescope.builtin').find_files({ find_command = { "fd", "--strip-cwd-prefix", "--type", "f" } })
			end, {} },
			{ "<leader>fg", function()
				require('telescope.builtin').live_grep()
			end, },
			{ "<leader>gs", function()
				require('telescope.builtin').grep_string()
			end, },
			{ "<leader>fb", function()
				require('telescope.builtin').buffers()
			end, },
			{ "<leader>fr", function()
				require('telescope.builtin').resume()
			end, },
			{ "<leader>fh", function()
				require('telescope.builtin').help_tags()
			end, },
			{ "<leader>lr", function()
				require('telescope.builtin').lsp_references()
			end, },
			{ "<leader>ld", function()
				require('telescope.builtin').diagnostics()
			end, },
			{ "<leader>li", function()
				require('telescope.builtin').lsp_implementations()
			end, },
			{ "<leader>ldf", function()
				require('telescope.builtin').lsp_definitions()
			end, },
			{ "n", "<leader>ltd", function()
				require('telescope.builtin').lsp_type_definitions()
			end, },
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = "BufRead",
		config = function()
			require("nvim-treesitter.configs").setup({
				autotag = {
					enable = true,
				},
				ensure_installed = {
					"c",
					"dart",
					"dockerfile",
					"fish",
					"go",
					"gomod",
					"gosum",
					"html",
					"java",
					"javascript",
					"json",
					"jsdoc",
					"json5",
					"kotlin",
					"lua",
					"luadoc",
					"make",
					"markdown_inline",
					"pug",
					"prisma",
					"rust",
					"sql",
					"svelte",
					"terraform",
					"typescript",
					"tsx",
					"yaml",
					"python",
				},
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
			})
		end
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = "BufRead",
		config = function()
			local null_ls = require("null-ls")

			local async_formatting = function(bufnr)
				bufnr = bufnr or vim.api.nvim_get_current_buf()

				vim.lsp.buf_request(
					bufnr,
					"textDocument/formatting",
					vim.lsp.util.make_formatting_params({}),
					function(err, res, ctx)
						if err then
							local err_msg = type(err) == "string" and err or err.message
							-- you can modify the log message / level (or ignore it completely)
							vim.notify("formatting: " .. err_msg, vim.log.levels.WARN)
							return
						end

						-- don't apply results if buffer is unloaded or has been modified
						if not vim.api.nvim_buf_is_loaded(bufnr) or vim.api.nvim_buf_get_option(bufnr, "modified") then
							return
						end

						if res then
							local client = vim.lsp.get_client_by_id(ctx.client_id)
							vim.lsp.util.apply_text_edits(res, bufnr, client and client.offset_encoding or "utf-16")
							vim.api.nvim_buf_call(bufnr, function()
								vim.cmd("silent noautocmd update")
							end)
						end
					end
				)
			end

			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})


			null_ls.setup({
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePost", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								async_formatting(bufnr)
							end,
						})
					end
					local format_cmd = function(input)
						vim.lsp.buf.format({
							id = client.id,
							timeout_ms = 5000,
							async = input.bang,
						})
					end

					local bufcmd = vim.api.nvim_buf_create_user_command
					bufcmd(bufnr, "NullFormat", format_cmd, {
						bang = true,
						range = true,
						desc = "Format using null-ls",
					})

					vim.keymap.set("n", "<leader>fs", "<cmd>NullFormat!<cr>", { buffer = bufnr })
				end,
				sources = {
					-- You can add tools not supported by mason.nvim

					null_ls.builtins.diagnostics.eslint,
					null_ls.builtins.diagnostics.fish,
					null_ls.builtins.code_actions.eslint,
					null_ls.builtins.formatting.prismaFmt,
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.rustfmt,
					null_ls.builtins.formatting.prettierd,
					null_ls.builtins.formatting.fish_indent,
				},
			})
		end
	},
	{
		"jay-babu/mason-null-ls.nvim",
		lazy = "BufRead",
		dependencies = {
			"williamboman/mason.nvim",
			"jose-elias-alvarez/null-ls.nvim",
		},
		config = function()
			-- See mason-null-ls.nvim's documentation for more details:
			-- https://github.com/jay-babu/mason-null-ls.nvim#setup
			require("mason-null-ls").setup({
				ensure_installed = { "prettierd", "eslint" },
				automatic_installation = true, -- You can still set this to `true`
				automatic_setup = true,
			})
		end
	},
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		event = "BufRead",
		config = function()
			local lsp = require("lsp-zero").preset({
				name = "recommended",
				set_lsp_keymaps = true,
				manage_nvim_cmp = true,
				suggest_lsp_servers = true,
			})


			lsp.ensure_installed({
				-- JS Crap
				"graphql",
				"html",
				"eslint",
				"cssls",
				"cssmodules_ls",
				"prismals",
				"svelte",
				"tailwindcss",
				"tsserver",
				-- Others
				"dockerls",
				"docker_compose_language_service",
				"gopls",
				"lua_ls",
				"remark_ls",
				"pyright",
				"sqlls",
				"rust_analyzer",
				"yamlls",
			})

			lsp.on_attach(function(client, bufnr)
				lsp.default_keymaps({ buffer = bufnr })
			end)

			local function organize_imports()
				local params = {
					command = "_typescript.organizeImports",
					arguments = { vim.api.nvim_buf_get_name(0) },
					title = "",
				}
				vim.lsp.buf.execute_command(params)
			end

			require("lspconfig").tsserver.setup({
				on_attach = function()
					vim.keymap.set("n", "<leader>oi", "<cmd>OrganizeImports<cr>", { noremap = true, silent = true })
				end,
				commands = {
					OrganizeImports = {
						organize_imports,
						description = "Organize Imports",
					},
				},
			})
			lsp.setup()
		end,
		dependencies = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },          -- Required
			{ "williamboman/mason.nvim" },        -- Optional
			{ "williamboman/mason-lspconfig.nvim" }, -- Optional

			-- Autocompletion
			{
				"hrsh7th/nvim-cmp",
				event = "BufRead",
				config = function()
					local cmp = require("cmp")
					cmp.setup({
						window = {
							completion = cmp.config.window.bordered(),
						},
						mapping = {
							["<C-Space>"] = cmp.mapping.complete(),
						},
					})
				end
			},                       -- Required
			{ "hrsh7th/cmp-nvim-lsp" }, -- Required
			{ "L3MON4D3/LuaSnip" },  -- Required
		},
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<leader>ee", "<cmd>NvimTreeToggle<cr>" },
			{ "<leader>ef", "<cmd>NvimTreeFocus<cr>" },
			{ "<leader>ec", "<cmd>NvimTreeFocus<cr>" },
		},
		config = function()
			local HEIGHT_RATIO = 0.8 -- You can change this
			local WIDTH_RATIO = 0.5

			require("nvim-tree").setup({
				update_focused_file = {
					enable = true,
					update_cwd = false,
					ignore_list = {},
				},
				view = {},
			})
		end
	},
	{
		"numToStr/Comment.nvim",
		event = "BufRead",
		config = function()
			require("Comment").setup({})
		end,
	},
	{
		"romgrk/barbar.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		version = "^1.0.0", -- optional: only update when a new 1.x version is released
		event = "VeryLazy",
		keys = {
			-- Move to previous/next

			{ "<S-TAB>",   "<Cmd>BufferPrevious<CR>", },
			{ "<TAB>",     "<Cmd>BufferNext<CR>", },
			-- Re-order to previous/next
			{ "<A-<>",     "<Cmd>BufferMovePrevious<CR>", },
			{ "<A->>",     "<Cmd>BufferMoveNext<CR>", },
			-- Goto buffer in position...
			{ "<A-1>",     "<Cmd>BufferGoto 1<CR>", },
			{ "<A-2>",     "<Cmd>BufferGoto 2<CR>", },
			{ "<A-3>",     "<Cmd>BufferGoto 3<CR>", },
			{ "<A-4>",     "<Cmd>BufferGoto 4<CR>", },
			{ "<A-5>",     "<Cmd>BufferGoto 5<CR>", },
			{ "<A-6>",     "<Cmd>BufferGoto 6<CR>", },
			{ "<A-7>",     "<Cmd>BufferGoto 7<CR>", },
			{ "<A-8>",     "<Cmd>BufferGoto 8<CR>", },
			{ "<A-9>",     "<Cmd>BufferGoto 9<CR>", },
			{ "<A-0>",     "<Cmd>BufferLast<CR>", },
			-- Pin/unpin buffer
			{ "<A-p>",     "<Cmd>BufferPin<CR>", },
			-- Close buffer
			{ "<leader>x", "<Cmd>BufferClose<CR>", },
			{ "<leader>w", "<Cmd>w<CR>", },
			-- Wipeout buffer
			--                 :BufferWipeout
			-- Close commands
			--                 :BufferCloseAllButCurrent
			--                 :BufferCloseAllButPinned
			--                 :BufferCloseAllButCurrentOrPinned
			--                 :BufferCloseBuffersLeft
			--                 :BufferCloseBuffersRight
			-- Magic buffer-picking mode
			{ "<C-p>",     "<Cmd>BufferPick<CR>", },
			-- Sort automatically by...
			{ "<Space>bb", "<Cmd>BufferOrderByBufferNumber<CR>", },
			{ "<Space>bd", "<Cmd>BufferOrderByDirectory<CR>", },
			{ "<Space>bl", "<Cmd>BufferOrderByLanguage<CR>", },
			{ "<Space>bw", "<Cmd>BufferOrderByWindowNumber<CR>", },

			{ "<C-h>",     "<Cmd>wincmd h<CR>", },
			{ "<C-j>",     "<Cmd>wincmd j<CR>", },
			{ "<C-k>",     "<Cmd>wincmd k<CR>", },
			{ "<C-l>",     "<Cmd>wincmd l<CR>", },
		}
	},
	{
		"windwp/nvim-ts-autotag",
		event = "BufRead",
	},
	{
		"windwp/nvim-autopairs",
		event = "BufRead",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{
		"tiagovla/scope.nvim",
		config = function()
			require("scope").setup()
		end
	},
	{
		"kdheepak/lazygit.nvim",
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", { silent = true, noremap = true } }
		}
	},
	{
		"akinsho/toggleterm.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<C-\\>",
				function()
					require("toggleterm").toggle(null, null, null, "float")
				end,
				mode = { "n", "t" }
			},
			{
				"<C-t>",
				function()
					require("toggleterm").toggle(null, null, null, "horizontal")
				end,
				mode = "n"
			},
			{
				"<C-`>",

				function()
					require("toggleterm").toggle(null, null, null, "vertical")
				end,
				mode = "n"
			},
		}
	},
	{
		"sidebar-nvim/sidebar.nvim",
		keys = {
			{ "<leader>sb", "<cmd>SidebarNvimToggle<cr>" },
		},
		event = "VeryLazy",
		config = function()
			require("sidebar-nvim").setup({
				open = false,
				side = "right",
				hide_statusline = true,
				sections = {
					"diagnostics",
					"git",
				},
			})
		end,
	},
	{
		"tpope/vim-fugitive",
		event = "VeryLazy"
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		config = function()
			require("lualine").setup()
		end,
	},
	{
		"justinmk/vim-sneak",
		event = "BufRead"
	},
	{
		"mg979/vim-visual-multi",
		event = "BufRead",
		config = function() end,
	},
}

require("lazy").setup(
	plugins, {
		defaults = {
			lazy = true
		},
	}
)
