return { -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-buffer',
  },
  config = function()
    -- See `:help cmp`
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    local tabCompleteFunction = cmp.mapping(function(fallback)
      if cmp.visible() then
        local entries = cmp.get_entries()
        local selected = cmp.get_selected_entry()
        if selected or #entries == 1 then
          -- Eintrag ausgewählt oder nur ein Eintrag vorhanden = füge ein
          cmp.confirm { select = true }
        else
          -- Sonst vervollständige bis zum gemeinsamen Präfix
          -- WICHTIG: damit die Funktion das tut, darf kein Eintrag ausgewählt sein!
          cmp.complete_common_string()
        end
      elseif luasnip.locally_jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, { 'i', 'c' })

    cmp.setup {
      preselect = cmp.PreselectMode.None,
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = {
        completeopt = 'menu,menuone,noinsert,noselect',
      },
      matching = {
        disallow_fuzzy_matching = true,
        disallow_fullfuzzy_matching = true,
        disallow_partial_fuzzy_matching = true,
        disallow_partial_matching = true,
        disallow_prefix_unmatching = false,
        disallow_symbol_nonprefix_matching = false,
      },

      mapping = cmp.mapping.preset.insert {
        ['<Tab>'] = tabCompleteFunction,
        ['<C-Space>'] = cmp.mapping.complete {},
      },
      sources = {
        {
          name = 'lazydev',
          -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
          group_index = 0,
        },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'nvim_lsp_signature_help' },
      },
    }
    local cmdline_mappings = cmp.mapping.preset.cmdline()
    cmdline_mappings['<Tab>'] = tabCompleteFunction
    -- Set up command-line completion (:)
    cmp.setup.cmdline(':', {
      mapping = cmdline_mappings,
      completeopt = 'menu,menuone,noinsert',
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        {
          name = 'cmdline',
          option = {
            ignore_cmds = { 'Man', '!' },
          },
        },
      }),
    })

    -- Set up search completion (/)
    cmp.setup.cmdline('/', {
      mapping = cmdline_mappings,
      sources = {
        { name = 'buffer' },
      },
    })
  end,
}
