return {
  'https://github.com/rcarriga/nvim-notify',
  config = function()
    local notify = require 'notify'
    vim.opt.termguicolors = true
    vim.notify = notify
    notify.setup {
      on_open = function(win)
        io.write '\7'
      end,
      background_colour = 'NotifyBackground',
      fps = 30,
      icons = {
        DEBUG = '',
        ERROR = '',
        INFO = '',
        TRACE = '✎',
        WARN = '',
      },
      level = 2,
      minimum_width = 50,
      render = 'default',
      stages = 'fade_in_slide_out',
      time_formats = {
        notification = '%T',
        notification_history = '%FT%T',
      },
      timeout = 5000,
      top_down = true,
    }
  end,
}
