local dap = require 'dap'

local function get_gdb_version()
  local handle = io.popen 'gdb --version'
  if not handle then
    return nil
  end
  local result = handle:read '*a'
  handle:close()
  local version = result:match 'GNU gdb%s+%d+%.%d+'
  if version then
    local major, minor = version:match '(%d+)%.(%d+)'
    return tonumber(major), tonumber(minor)
  end
  return nil
end

local major, minor = get_gdb_version()
if major and major >= 14 then
  dap.adapters.cppdbg = {
    type = 'executable',
    command = 'gdb',
    args = { '--interpreter=dap', '--eval-command', 'set print pretty on' },
  }
else
  local download_path = '/tmp/vscode-cpptools.zip'
  local extract_dir = '/tmp/vscode-cpptools'
  local bin_path = extract_dir .. '/extension/debugAdapters/bin/OpenDebugAD7'
  if vim.fn.filereadable(bin_path) == 0 then
    local download_cmd = 'curl -L -o ' .. download_path .. ' https://github.com/microsoft/vscode-cpptools/releases/download/v1.27.7/cpptools-linux-x64.vsix'
    local download_result = os.execute(download_cmd)
    local unzip_cmd = 'unzip -o ' .. download_path .. ' -d ' .. extract_dir
    local unzip_result = os.execute(unzip_cmd)
    local chmod_cmd = 'chmod +x ' .. bin_path
    local chmod_resut = os.execute(chmod_cmd)
  end
  dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = bin_path,
  }
end
dap.configurations.c = {
  {
    name = 'Launch',
    type = 'gdb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = 'Select and attach to process',
    type = 'gdb',
    request = 'attach',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    pid = function()
      local name = vim.fn.input 'Executable name (filter): '
      return require('dap.utils').pick_process { filter = name }
    end,
    cwd = '${workspaceFolder}',
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'gdb',
    request = 'attach',
    target = 'localhost:1234',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
  },
}
