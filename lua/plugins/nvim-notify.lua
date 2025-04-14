return {
  'https://github.com/rcarriga/nvim-notify',
  config = function()
    local notify = require 'notify'
    vim.opt.termguicolors = true
    vim.notify = notify
  end,
}
