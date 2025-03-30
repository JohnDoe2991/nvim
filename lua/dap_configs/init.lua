-- Path to the 'dap' folder
local dap_folder = vim.fn.stdpath 'config' .. '/lua/dap_configs'

-- Automatically load all Lua files in the 'dap' folder
for _, file in ipairs(vim.fn.glob(dap_folder .. '/*.lua', true, true)) do
  dofile(file)
end
