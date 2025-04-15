return {
  'karb94/neoscroll.nvim',
  opts = {},
  keys = {
    {
      '<PageUp>',
      function()
        require('neoscroll').ctrl_u { duration = 150 }
      end,
      desc = 'Scroll Up',
    },
    {
      '<PageDown>',
      function()
        require('neoscroll').ctrl_d { duration = 150 }
      end,
      desc = 'Scroll Down',
    },
  },
}
