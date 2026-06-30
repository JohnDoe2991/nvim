local M = {}

local macro_register = 'a'

local function visual_selection()
  local mode = vim.fn.mode()
  if mode ~= 'v' and mode ~= 'V' and mode ~= '\22' then
    return nil, 'Select macro text in visual mode first'
  end

  local lines = vim.fn.getregion(vim.fn.getpos 'v', vim.fn.getpos '.')
  local text = table.concat(lines, '\n')
  if text == '' then
    return nil, 'Empty selection'
  end

  return text, nil
end

function M.macro_to_readable(macro)
  -- keytrans() prints internal key bytes as Vim key notation, e.g. Escape as
  -- <Esc>. Literal text that looks like key notation is escaped as <lt>esc>,
  -- so typed text "<esc>" can be distinguished from pressing the Escape key.
  return vim.fn.keytrans(macro)
end

function M.readable_to_macro(text)
  -- vim.keycode() converts Vim key notation back to the internal bytes stored
  -- in macro registers. Escaped <lt> sequences become literal "<" again, so
  -- the keytrans() output round-trips without confusing text with key presses.
  if vim.keycode then
    return vim.keycode(text)
  end

  return vim.api.nvim_replace_termcodes(text, true, true, true)
end

function M.decode_base64_macro(text)
  local ok, decoded = pcall(vim.base64.decode, text)
  if not ok then
    return nil, decoded
  end

  return decoded, nil
end

function M.insert_reg_as_readable()
  local macro = vim.fn.getreg(macro_register)
  if not macro or macro == '' then
    vim.notify(('Register "%s" is empty'):format(macro_register), vim.log.levels.WARN)
    return
  end

  vim.api.nvim_put({ M.macro_to_readable(macro) }, 'c', true, true)
  vim.notify(('Pasted readable macro from register "%s"'):format(macro_register), vim.log.levels.INFO)
end

function M.load_reg_from_visual_readable()
  local text, err = visual_selection()
  if not text then
    vim.notify(err, vim.log.levels.WARN)
    return
  end

  vim.fn.setreg(macro_register, M.readable_to_macro(text), 'c')
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)

  vim.notify(('Loaded readable macro into register "%s"'):format(macro_register), vim.log.levels.INFO)
end

function M.load_reg_from_visual_base64()
  local text, err = visual_selection()
  if not text then
    vim.notify(err, vim.log.levels.WARN)
    return
  end

  local decoded, decode_err = M.decode_base64_macro(text)
  if not decoded then
    vim.notify('Invalid base64 selection: ' .. tostring(decode_err), vim.log.levels.ERROR)
    return
  end

  vim.fn.setreg(macro_register, decoded, 'c')
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)

  vim.notify(('Loaded base64 macro into register "%s"'):format(macro_register), vim.log.levels.INFO)
end

return M
