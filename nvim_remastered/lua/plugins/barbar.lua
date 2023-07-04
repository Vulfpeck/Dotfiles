return {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  },
  config = function()
    require("barbar").setup({
      gitsigns = {
        added = { enabled = true, icon = '+' },
        changed = { enabled = true, icon = '~' },
        deleted = { enabled = true, icon = '-' },
      },
    })
  end,
  event = "BufRead",
  keys = {
    { "<tab>",      ":BufferNext<CR>" },
    { "<S-tab>",    ":BufferPrevious<CR>" },
    { "<leader>x",  ":BufferClose<CR>" },
    { "<leader>xa", ":BufferCloseAllButCurrent<CR>" },
    { "<leader>xr", ":BufferCloseRight<CR>" },
    { "<leader>xl", ":BufferCloseLeft<CR>" },
  }
}
