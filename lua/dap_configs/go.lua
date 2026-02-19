-- ToDo: mason-tool-installer does not support multiple calls to setup or adding to ensure_installed
-- see: https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim/issues/44
-- require('mason-tool-installer').setup { ensure_installed = { 'delve' } }
local dap = require 'dap'
dap.adapters.go = function(callback, config)
  if config.mode == 'remote' and config.request == 'attach' then
    callback {
      type = 'server',
      host = config.host or '127.0.0.1',
      port = config.port or '38697',
    }
  else
    callback {
      type = 'server',
      port = '${port}',
      executable = {
        command = 'dlv',
        args = { 'dap', '-l', '127.0.0.1:${port}', '--log', '--log-output=dap' },
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end
end

-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
  {
    type = 'go',
    name = 'Debug test', -- configuration for debugging test files
    request = 'launch',
    mode = 'test',
    program = '${file}',
  },
}
