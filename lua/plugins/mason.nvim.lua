return {
  'williamboman/mason.nvim',
  opts = {},
  config = function(_, opts)
    require('mason').setup(opts)

    local registry = require 'mason-registry'
    -- list of tools to install automatically
    -- currently there is no way to install tools in each plugin, so we collect them here
    local tools = {
      'tree-sitter-cli', -- for treesitter
    }

    local function ensure_tools_installed()
      for _, tool in ipairs(tools) do
        if not registry.has_package(tool) then
          vim.notify('Mason package not found: ' .. tool, vim.log.levels.WARN)
        elseif not registry.is_installed(tool) then
          registry.get_package(tool):install({}, function(success, err)
            if success == false then
              vim.notify(tool .. ': ' .. tostring(err), vim.log.levels.ERROR)
            end
          end)
        end
      end
    end

    if registry.refresh then
      registry.refresh(ensure_tools_installed)
    else
      ensure_tools_installed()
    end
  end,
}
