-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

local function find_copilot_terminal_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == 'terminal' then
      local name = vim.api.nvim_buf_get_name(buf)
      if name:match 'copilot_start' then
        return buf
      end
    end
  end
  return nil
end

local function open_or_focus_copilot_terminal()
  local buf = find_copilot_terminal_buf()
  if buf then
    vim.api.nvim_set_current_buf(buf)
    vim.cmd 'startinsert'
    return
  end

  vim.cmd 'terminal copilot_start'
  vim.cmd 'startinsert'
end

local function flash_linewise_yank(start_line, end_line)
  local ns = vim.api.nvim_create_namespace 'custom-copy-yank-highlight'
  for line = start_line - 1, end_line - 1 do
    vim.api.nvim_buf_add_highlight(0, ns, 'IncSearch', line, 0, -1)
  end
  vim.defer_fn(function()
    pcall(vim.api.nvim_buf_clear_namespace, 0, ns, 0, -1)
  end, 160)
end

local function clean_linewise_selection_to_clipboard()
  local mode = vim.fn.mode()
  local start_line
  local end_line

  if mode == 'v' or mode == 'V' or mode == '\22' then
    start_line = vim.fn.getpos 'v'[2]
    end_line = vim.fn.getpos '.'[2]
  else
    start_line = vim.fn.getpos "'<"[2]
    end_line = vim.fn.getpos "'>"[2]
  end

  if start_line == 0 or end_line == 0 then
    return
  end
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  for i, line in ipairs(lines) do
    lines[i] = line:gsub('%s*┃%s*$', '')
  end
  local cleaned = table.concat(lines, '\n') .. '\n'
  vim.fn.setreg('+', cleaned, 'V')
  vim.fn.setreg('"', cleaned, 'V')
  flash_linewise_yank(start_line, end_line)
end

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-left>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-right>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-up>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-down>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<leader>wq', '<cmd>close<cr>', { desc = 'Close current window' })
vim.keymap.set('n', '<leader>wv', '<cmd>vsplit<cr>', { desc = 'Split current window vertically' })

vim.keymap.set('n', '<leader>bq', '<cmd>:bd<cr>', { desc = 'Close buffer' })
vim.keymap.set({ 'n', 't' }, '<leader>cp', open_or_focus_copilot_terminal, { desc = 'Open or focus Copilot CLI terminal' })
vim.keymap.set('x', '<leader>cy', clean_linewise_selection_to_clipboard, { desc = 'Copy visual selection without TUI scrollbar' })
vim.api.nvim_create_user_command('Copilot', open_or_focus_copilot_terminal, { desc = 'Open or focus Copilot CLI terminal' })
vim.cmd 'cnoreabbrev <expr> copilot getcmdtype() == ":" && getcmdline() == "copilot" ? "Copilot" : "copilot"'

-- toggle line wrap
vim.keymap.set('n', '<leader>tw', function()
  vim.wo.wrap = not vim.wo.wrap
  print('Line wrap: ' .. (vim.wo.wrap and 'ON' or 'OFF'))
end, { desc = 'Toggle line wrap' })

-- paste and load macros as base64 encoded string
local macro_b64 = require 'macro_save_load'
vim.keymap.set('n', '<leader>mp', function()
  macro_b64.insert_reg_as_base64()
end, { desc = 'Insert selected macro register as base64' })

vim.keymap.set('v', '<leader>my', function()
  macro_b64.load_reg_from_visual_base64()
end, { desc = 'Load selected macro register from base64 selection' })
