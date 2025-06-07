return {
  'L3MON4D3/LuaSnip',
  build = (function()
    -- Build Step is needed for regex support in snippets.
    -- This step is not supported in many windows environments.
    -- Remove the below condition to re-enable on windows.
    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
      return
    end
    return 'make install_jsregexp'
  end)(),
  dependencies = {},
  config = function()
    local ls = require 'luasnip'
    ls.config.setup {}
    local vscode_loader = require 'luasnip.loaders.from_vscode'

    -- Load global snippets
    vscode_loader.lazy_load()

    local function load_project_snippets()
      local cwd = vim.fn.getcwd()
      local vscode_path = cwd .. '/.vscode'

      -- Check if .vscode directory exists
      if vim.fn.isdirectory(vscode_path) == 1 then
        -- Get all .code-snippets files in the .vscode directory
        local snippet_files = vim.fn.glob(vscode_path .. '/*.code-snippets', false, true)

        -- Load each .code-snippets file individually
        for _, file_path in ipairs(snippet_files) do
          vscode_loader.load_standalone {
            path = file_path,
          }
        end
      end
    end

    load_project_snippets()

    -- Also load snippets when changing directory
    vim.api.nvim_create_autocmd('DirChanged', {
      callback = load_project_snippets,
    })
  end,
}
