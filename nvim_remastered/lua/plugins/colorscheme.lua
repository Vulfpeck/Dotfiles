return {
  -- "neanias/everforest-nvim",
  "sainnhe/everforest",
  config = function()
    vim.cmd("set termguicolors")
    vim.cmd("set background=dark")
    vim.cmd("let g:everforest_better_performance = 1")
    vim.cmd("let g:everforest_enable_italic = 1")
    vim.cmd("let g:everforest_transparent_background = 2")
    vim.cmd("colorscheme everforest")
  end,
  lazy = false
}
