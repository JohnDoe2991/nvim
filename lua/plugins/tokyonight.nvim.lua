return { -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command in the config to whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  'folke/tokyonight.nvim',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    configStruct = {
      styles = {
        comments = { italic = false }, -- Disable italics in comments
      },
      on_highlights = function(highlights, colors)
        -- make autocompletes more visible
        highlights.Pmenu = { bg = '#03344E' }
        -- make lsp infos more readable
        highlights.NormalFloat = { bg = '#03344E' }
      end,
    }
    if string.lower(vim.env["TERM"]) == "alacritty" then
      -- alacritty terminal detected, activate transparency
      configStruct.transparent = true
      configStruct.styles.sidebars = "transparent"
      configStruct.styles.floats = "transparent"
    end
    require('tokyonight').setup(configStruct)

    -- Load the colorscheme here.
    -- Like many other themes, this one has different styles, and you could load
    -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    vim.cmd.colorscheme 'tokyonight-night'
  end,
}
