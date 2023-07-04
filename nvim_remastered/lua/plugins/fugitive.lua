return {
  'tpope/vim-fugitive',
  event = "BufRead",
  config = function()
    vim.cmd(":set diffopt+=vertical")
  end
}
