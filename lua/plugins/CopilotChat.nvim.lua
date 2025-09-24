return {
  'CopilotC-Nvim/CopilotChat.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim', branch = 'master' },
  },
  build = 'make tiktoken',
  keys = {
    { '<leader>cc', '<cmd>CopilotChatToggle<cr>', desc = 'open Copilot Chat' },
  },
}
