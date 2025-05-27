-- Path to the 'dap' folder
local dap_folder = vim.fn.stdpath 'config' .. '/lua/dap_configs'

-- Automatically load all Lua files in the 'dap' folder
for _, file in ipairs(vim.fn.glob(dap_folder .. '/*.lua', true, true)) do
  -- Only execute if the filename is not 'init.lua'
  if not file:match 'init%.lua$' then
    dofile(file)
  end
end
