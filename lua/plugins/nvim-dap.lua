return {
  'mfussenegger/nvim-dap',
  dependencies = {
    { 'williamboman/mason.nvim', opts = {} }, -- install dependencies in dap configs
    'WhoIsSethDaniel/mason-tool-installer.nvim', -- install dependencies in dap configs
  },
  lazy = true,
}
