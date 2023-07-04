return {
  'nvim-treesitter/nvim-treesitter',
  event = 'BufRead',
  config = function()
    require("nvim-treesitter.configs").setup({
      auto_install = true,
      sync_install = true,
    })
  end
}
