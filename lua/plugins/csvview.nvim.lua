return {
  'hat0uma/csvview.nvim',
  opts = {
    parser = {
      comments = { '#', '//' },
      delimiter = {
        default = ';',
      },
      quote_char = '"',
    },
    keymaps = {},
    view = {
      header_lnum = 1,
    },
    cmd = { 'CsvViewEnable', 'CsvViewDisable', 'CsvViewToggle' },
  },
  keys = {
    { '<leader>t,', '<cmd>CsvViewToggle delimiter=,<cr>', desc = 'Toggle format csv with ,' },
    { '<leader>t;', '<cmd>CsvViewToggle delimiter=;<cr>', desc = 'Toggle format csv with ;' },
  },
}
