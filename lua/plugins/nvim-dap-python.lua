return {
  'mfussenegger/nvim-dap-python',
  dependencies = {
    'mfussenegger/nvim-dap',
  },
  config = function()
    local dap_python = require 'dap-python'
    dap_python.setup 'uv'
    dap_python.test_runner = 'pytest'
  end,
}
