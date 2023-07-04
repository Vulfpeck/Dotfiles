require("lazy").setup({
  require("plugins.colorscheme"),
  require("plugins.lsp"),
  require("plugins.telescope"),
  require("plugins.surround"),
  require("plugins.autopairs"),
  require("plugins.barbar"),
  require('plugins.treesitter'),
  require("plugins.lazygit"),
  require("plugins.fugitive"),
  require("plugins.nvim-tree"),
  require("plugins.gitsigns"),
}, {
  defaults = {
    lazy = true
  }
})
