return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration
    'nvim-telescope/telescope.nvim', -- optional
  },
  opts = {
    graph_style = 'unicode',
  },
  keys = {
    { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Neogit project status' },
    { '<leader>gl', '<cmd>Neogit log<cr>', desc = 'Neogit log graph' },
  },
}
