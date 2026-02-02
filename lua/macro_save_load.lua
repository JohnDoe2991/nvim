local M = {}

-- Insert base64-encoded contents of register {reg} at the cursor position.
function M.insert_reg_as_base64()
  local reg = 'a'

  local macro = vim.fn.getreg(reg)
  if not macro or macro == '' then
    vim.notify(('Register "%s" is empty'):format(reg), vim.log.levels.WARN)
    return
  end

  local b64 = vim.base64.encode(macro)
  vim.api.nvim_put({ b64 }, 'c', true, true)
  vim.notify(('Pasted encoded macro from register "%s"'):format(reg), vim.log.levels.INFO)
end

-- Decode base64 from the current visual selection and set it into register {reg}.
function M.load_reg_from_visual_base64()
  -- i cannot figure out how to set the register in visual mode; it should work with operatorfunc, but it does not
  local reg = 'a'

  local mode = vim.fn.mode()
  if mode ~= 'v' and mode ~= 'V' and mode ~= '\22' then
    vim.notify('Select a base64 text in visual mode first', vim.log.levels.WARN)
    return
  end

  local b64 = table.concat(vim.fn.getregion(vim.fn.getpos 'v', vim.fn.getpos '.'), '\n')

  if not b64 then
    vim.notify('Empty selection', vim.log.levels.WARN)
    return
  end

  local ok, decoded = pcall(vim.base64.decode, b64)
  if not ok then
    vim.notify('Invalid base64 selection: ' .. tostring(decoded), vim.log.levels.ERROR)
    return
  end

  vim.fn.setreg(reg, decoded, 'c')
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)

  vim.notify(('Loaded decoded macro into register "%s"'):format(reg), vim.log.levels.INFO)
end

return M
