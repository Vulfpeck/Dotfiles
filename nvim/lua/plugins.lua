local plugins = {
	{
		"sainnhe/gruvbox-material",
	},
	{ 'savq/melange-nvim'},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{ "nvim-treesitter/nvim-treesitter" },
	{ "jose-elias-alvarez/null-ls.nvim" },
	{
		"jay-babu/mason-null-ls.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"jose-elias-alvarez/null-ls.nvim",
		},
	},
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		dependencies = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" }, -- Required
			{ "williamboman/mason.nvim" }, -- Optional
			{ "williamboman/mason-lspconfig.nvim" }, -- Optional

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" }, -- Required
			{ "hrsh7th/cmp-nvim-lsp" }, -- Required
			{ "L3MON4D3/LuaSnip" }, -- Required
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
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({})
		end,
	},
	{
		"romgrk/barbar.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		version = "^1.0.0", -- optional: only update when a new 1.x version is released
	},
	{
		"windwp/nvim-ts-autotag",
	},
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{
		"tiagovla/scope.nvim",
	},
	{
		"kdheepak/lazygit.nvim",
		init = function() end,
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = {},
	},
	{
		"sidebar-nvim/sidebar.nvim",
		config = function()
			require("sidebar-nvim").setup({
				open = false,
				side = "right",
				hide_statusline = false,
				sections = {
					"symbols",
					"diagnostics",
					"buffers",
					"git",
				},
			})
		end,
	},
	{
		"tpope/vim-fugitive",
	},
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup()
		end,
	},
	{
		"justinmk/vim-sneak",
	},
	{
		"mg979/vim-visual-multi",
		config = function() end,
	},
}

require("lazy").setup(plugins, {})
