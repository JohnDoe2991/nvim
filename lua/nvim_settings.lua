--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    -- first we check if a terminal can be detected which uses full OSC52 support
    local isKitty = string.lower(vim.env['TERM'] or '') == 'xterm-kitty'
    local isAlacritty = string.lower(vim.env['TERM'] or '') == 'alacritty'
    local isWsltty = string.lower(vim.env['HOSTTERM'] or '') == 'mintty'
    -- windows terminal does not set HOSTTERM automatically, see https://learn.microsoft.com/en-us/windows/terminal/tips-and-tricks#environment-variables-per-profile and set for your profile
    local isWindowsTerminal = string.lower(vim.env['HOSTTERM'] or '') == 'windowsterminal'
    local activateOSC52 = false
    if isKitty or isAlacritty or isWsltty or isWindowsTerminal then
      activateOSC52 = true
    end
    if not activateOSC52 and vim.o.compatible == false then
      local answer = vim.fn.input 'OSC 52 support not detected. Enable OSC52 clipboard support anyway? (y/n): '
      if string.lower(answer) == 'y' then
        activateOSC52 = true
      end
    end
    if activateOSC52 then
      -- dont use special registers like "*" and "+" automatically
      -- instead we remap "y" and "<leader>p" to to store its values in "+"
      -- this way we prevent all other commands like "c" or "x" to constantly override the clipboard
      vim.opt.clipboard = ''
      vim.keymap.set({ 'n', 'x' }, 'y', function()
        local reg = vim.v.register
        if reg == '"' then
          reg = '+'
        end
        return '"' .. reg .. 'y'
      end, { expr = true, silent = true })

      vim.g.clipboard = 'osc52'

      vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'Paste clipboard' })
      vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P', { desc = 'Paste clipboard above' })
    else
      vim.opt.clipboard = 'unnamedplus'
      vim.keymap.set({ 'n', 'v' }, '<leader>p', '"0p', { desc = 'Paste last yank' })
      vim.keymap.set({ 'n', 'v' }, '<leader>P', '"0P', { desc = 'Paste last yank above' })
    end
  end,
})

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

vim.opt.tabstop = 4

-- ignore all whitespace changes in diff, use "better" diff algorithm and indent diffs
vim.opt.diffopt = { 'internal', 'filler', 'closeoff', 'linematch:60', 'algorithm:patience', 'iwhiteall', 'indent-heuristic' }
