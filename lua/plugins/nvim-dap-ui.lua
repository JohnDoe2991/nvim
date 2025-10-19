return {
  'rcarriga/nvim-dap-ui',
  dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
  config = function()
    local dap, dapui = require 'dap', require 'dapui'
    dapui.setup {
      element_mappings = {
        stacks = {
          -- make stacktrace open element if selected
          open = '<CR>',
          expand = 'o',
        },
      },
    }
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
  end,
  keys = {
    {
      '<leader>dd',
      function()
        require('dapui').toggle()
      end,
      desc = 'Toggle Debug Overlay',
    },
    { '<leader>db', '<cmd>DapToggleBreakpoint<cr>', desc = 'Toggle Breakpoint' },
    { '<leader>dq', '<cmd>DapTerminate<cr>', desc = 'Stop Debugging' },
    { '<leader>ds', '<cmd>DapContinue<cr>', desc = 'Start/Continue Debugging' },
  },
}
