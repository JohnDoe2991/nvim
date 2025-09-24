return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration
    'nvim-telescope/telescope.nvim', -- optional
  },
  opts = {
    graph_style = 'kitty',
  },
  keys = {
    -- workaround for submodule support, see: https://github.com/NeogitOrg/neogit/issues/870
    {
      '<leader>gg',
      function()
        local file_dir = vim.fn.expand '%:h'
        if vim.fn.isdirectory(file_dir) == 0 then
          require('neogit').open { kind = 'tab' }
          return
        end
        local exec_result = vim.system({ 'git', 'rev-parse', '--show-toplevel' }, { text = true, cwd = file_dir }):wait()
        local root = vim.fn.trim(exec_result.stdout)
        require('neogit').open { kind = 'tab', cwd = root }
      end,
      desc = 'Neogit status',
      silent = true,
    },
    { '<leader>gl', '<cmd>Neogit log<cr>', desc = 'Neogit log graph' },
  },
}
