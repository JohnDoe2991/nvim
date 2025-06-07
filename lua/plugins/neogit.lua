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
    -- workaround for submodule support, see: https://github.com/NeogitOrg/neogit/issues/870
    {
      'n',
      '<leader>gg',
      function()
        local file_dir = vim.fn.expand '%:h'
        local exec_result = vim.system({ 'git', 'rev-parse', '--show-toplevel' }, { text = true, cwd = file_dir }):wait()
        local root = vim.fn.trim(exec_result.stdout)
        require('neogit').open { kind = 'replace', cwd = root }
      end,
      desc = 'Neogit status',
      silent = true,
    },
    { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Neogit project status' },
    { '<leader>gl', '<cmd>Neogit log<cr>', desc = 'Neogit log graph' },
  },
}
