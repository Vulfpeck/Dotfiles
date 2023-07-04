return {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.g.nvim_tree_quit_on_open = 0

    -- open newly created file
    local api = require("nvim-tree.api")
    api.events.subscribe(api.events.Event.FileCreated, function(file)
      vim.cmd("edit " .. file.fname)
    end)

    -- autofocus opened file
    require("nvim-tree").setup({
      on_attach = function(bufnr)
        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        local ok, api = pcall(require, "nvim-tree.api")
        assert(ok, "api module is not found")
        vim.keymap.set("n", "<CR>", api.node.open.tab_drop, opts("Tab drop"))
      end,

      filters = {
        dotfiles = false,
      },
      update_focused_file = {
        enable = true,
        ignore_list = {},
      },
    })
  end,
  keys = {
    { "<leader>ee", ":NvimTreeToggle<CR>" }
  }
}
