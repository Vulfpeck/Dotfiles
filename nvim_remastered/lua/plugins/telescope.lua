return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  event = 'VeryLazy',
  config = function()
    require('telescope').setup({
      pickers = {
        find_files = {
          hidden = true,
          theme = "ivy",
          previewer = false,
        },
        live_grep = {
          hidden = true,
          theme = "ivy",
          previewer = true,
        },
        buffers = {
          hidden = true,
          theme = "ivy",
          previewer = false,
        },
        lsp_references = {
          theme = "cursor",
          previewer = true
        },
        lsp_definitions = {
          theme = "cursor",
          previewer = true
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,                   -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true,    -- override the file sorter
          case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
          -- the default case_mode is "smart_case"
        },
      },
    })
    require("telescope").load_extension("fzf")
  end,
  keys = {
    { "<leader>ff", function()
      require('telescope.builtin').find_files({
        find_command = { "fd", "--strip-cwd-prefix", "--type", "f" },
      })
    end, },
    { "<leader>fg", function() require('telescope.builtin').live_grep() end, },
    { "<leader>fs", function() require('telescope.builtin').grep_string() end, },
    { "<leader>fr", function() require('telescope.builtin').resume() end, },
    { "<leader>fb", function() require('telescope.builtin').buffers() end, },
    { "<leader>fh", function() require('telescope.builtin').help_tags() end, },
  }
}
