return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Useful status updates for LSP.
    { 'j-hui/fidget.nvim', opts = {} },

    -- Allows extra capabilities provided by nvim-cmp
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    -- Store log lines during setup
    local log_lines = {}

    -- Function to add log lines during setup (like print() with multiple arguments)
    local function add_log_line(...)
      local args = { ... }
      local parts = {}

      for _, arg in ipairs(args) do
        table.insert(parts, tostring(arg))
      end

      local line = table.concat(parts, '')
      table.insert(log_lines, line)
    end

    -- Function to display log lines in a buffer
    local function show_skipped_installs()
      -- Create a new buffer
      local buf = vim.api.nvim_create_buf(false, true)

      -- Set buffer options
      vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
      vim.api.nvim_buf_set_option(buf, 'swapfile', false)
      vim.api.nvim_buf_set_option(buf, 'modifiable', false)
      vim.api.nvim_buf_set_option(buf, 'buflisted', false)

      -- Set buffer name
      vim.api.nvim_buf_set_name(buf, 'LSP Skipped Installs')

      -- Create a new window and set the buffer
      vim.cmd 'split'
      vim.api.nvim_win_set_buf(0, buf)

      -- Make buffer modifiable temporarily to add content
      vim.api.nvim_buf_set_option(buf, 'modifiable', true)

      -- Add log lines to buffer
      if #log_lines > 0 then
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, log_lines)
      else
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { 'No skipped installs to display' })
      end

      -- Make buffer read-only again
      vim.api.nvim_buf_set_option(buf, 'modifiable', false)

      -- Set up key mapping to close buffer with 'q'
      vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q<CR>', {
        noremap = true,
        silent = true,
        desc = 'Close log buffer',
      })

      -- Set filetype for potential syntax highlighting
      vim.api.nvim_buf_set_option(buf, 'filetype', 'log')

      -- Move cursor to top
      vim.api.nvim_win_set_cursor(0, { 1, 0 })
    end

    -- Create the user command
    vim.api.nvim_create_user_command('LspSkippedInstalls', show_skipped_installs, {
      desc = 'Show LSP skipped installs log',
    })

    -- Remove Global Default Keymaps: https://neovim.io/doc/user/lsp.html#_global-defaults
    vim.keymap.del('n', 'grn')
    vim.keymap.del({ 'n', 'v' }, 'gra')
    vim.keymap.del('n', 'grr')
    vim.keymap.del('n', 'gri')
    vim.keymap.del('n', 'gO')

    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { desc = desc })
    end

    -- Jump to the definition of the word under your cursor.
    --  This is where a variable was first declared, or where a function is defined, etc.
    --  To jump back, press <C-t>.
    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

    -- Find references for the word under your cursor.
    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

    -- Jump to the implementation of the word under your cursor.
    --  Useful when your language has ways of declaring types without an actual implementation.
    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    map('<leader>ss', require('telescope.builtin').lsp_document_symbols, 'Document [S]ymbols')

    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    map('<leader>sS', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace [S]ymbols')

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    map('<leader>r', vim.lsp.buf.rename, '[R]ename')

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    map('<leader>i', vim.lsp.buf.hover, 'LSP info for current selection')

    -- The following code creates a keymap to toggle inlay hints in your
    map('<leader>th', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
    end, '[T]oggle Inlay [H]ints')

    -- Diagnostic Config
    -- See :help vim.diagnostic.Opts
    vim.diagnostic.config {
      severity_sort = true,
      virtual_lines = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},
      -- virtual_text = {
      -- source = 'if_many',
      -- spacing = 2,
      -- format = function(diagnostic)
      -- local diagnostic_message = {
      -- [vim.diagnostic.severity.ERROR] = diagnostic.message,
      -- [vim.diagnostic.severity.WARN] = diagnostic.message,
      -- [vim.diagnostic.severity.INFO] = diagnostic.message,
      -- [vim.diagnostic.severity.HINT] = diagnostic.message,
      -- }
      -- return diagnostic_message[diagnostic.severity]
      -- end,
      -- },
    }

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- this list contains all lsp servers which get enabled
    -- each lsp has a structure with several fields:
    -- mason_name: the binary name within mason to install it; if no name is provided, then the first argument in cmd from the lsp config will be used
    -- mason_dependencies: a list of tools which have to present in order to install it with mason; if these are not present, the lsp will not be enabled
    -- mason_additionals: a list of tools which need to be installed for the lsp to work, the first argument is the mason name, the second the cmd name
    -- config_override: a struct which gets merged with vim.lsp.config, see: https://neovim.io/doc/user/lsp.html#vim.lsp.config()
    --
    local servers = {
      clangd = {
        mason_dependencies = { 'unzip' },
      },
      gopls = {
        mason_dependencies = { 'go' },
      },
      pylsp = {
        mason_name = 'python-lsp-server',
        mason_dependencies = { 'python3' },
        config_override = {
          settings = {
            pylsp = {
              plugins = {
                pycodestyle = {
                  maxLineLength = 200,
                },
              },
            },
          },
        },
      },
      rust_analyzer = {},
      lua_ls = {
        mason_additionals = { { 'stylua', 'stylua' } },
        config_override = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      },
      templ = {},
      superhtml = {}, -- the normal html lsp is from Microsoft and uses Typescript, which requires a up to date node.js on the system
      htmx = {
        mason_dependencies = { 'cargo' },
      },
      jsonls = {
        mason_dependencies = { 'npm' },
        mason_name = 'json-lsp',
      },
      nixd = {},
      qmlls = {},
    }

    local registry = require 'mason-registry'
    if os.getenv 'NIX_PATH' ~= nil then
      add_log_line 'special os detected: NixOS'
    end
    for servername, config in pairs(servers) do
      local lsp_config = vim.lsp.config[servername]
      local cmd_name = lsp_config.cmd[1]
      local mason_name = config.mason_name or cmd_name
      local mason_dependencies = config.mason_dependencies or {}
      local mason_additionals = config.mason_additionals or {}
      local lsp_config_override = config.config_override or {}
      if os.getenv 'NIX_PATH' ~= nil then
        -- we are on nixOS, only check if cmd is available and skip if not
        if vim.fn.executable(cmd_name) == 0 then
          add_log_line('LSP ', servername, ' skipped: not found exe: ', cmd_name)
          goto continue
        end
        for _, mason_additional in ipairs(mason_additionals) do
          if vim.fn.executable(mason_additional[2]) == 0 then
            add_log_line('LSP ', servername, ' skipped: not found additional exe: ', mason_additional)
            goto continue
          end
        end
      else
        -- normal operating system, check first for dependencies
        for _, mason_dependency in ipairs(mason_dependencies) do
          if vim.fn.executable(mason_dependency) == 0 then
            add_log_line('LSP ', servername, ' skipped: not found dependency: ', mason_dependency)
            goto continue
          end
        end
        -- dependencies seem to be here, check if tool is in mason available
        if not registry.has_package(mason_name) then
          add_log_line('LSP ', servername, ' skipped: not found mason package: ', mason_name)
          goto continue
        end
        -- install tool
        if not registry.is_installed(mason_name) then
          registry.get_package(mason_name):install({}, function(success, error)
            if success == false then
              require 'notify'(mason_name .. ': ' .. tostring(error), 'error')
            end
          end)
        end
        -- install additional tools
        for _, mason_additional in ipairs(mason_additionals) do
          if not registry.is_installed(mason_additional[1]) then
            registry.get_package(mason_additional[1]):install()
          end
        end
      end
      -- override lsp config
      vim.lsp.config[servername] = vim.tbl_deep_extend('force', lsp_config, lsp_config_override)
      -- finally enable everything
      vim.lsp.enable(servername)
      ::continue::
    end
  end,
}
