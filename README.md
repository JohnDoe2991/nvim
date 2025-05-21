# Johnny's NeoVim Config

This is my personal NeoVim config.

It is based on (https://github.com/nvim-lua/kickstart.nvim)[kickstart] and will (hopefully) grow from there on.

## Installation
Clone this repo into your `$HOME/.config/` folder and install NeoVim manually.

Or execute this command to do everything automatically (not supported on all platforms):
```
bash <(curl -sL https://raw.githubusercontent.com/JohnDoe2991/nvim/master/setup_nvim.sh)
```

## Plugins

### fidget.nvim

https://github.com/j-hui/fidget.nvim

Benachrichtigungen rechts unten im Eck

### gitsigns.nvim

https://github.com/lewis6991/gitsigns.nvim

Git Integration in den Buffer

Diverse Funktionen wie:
- geänderte/gelöschte/hinzugefügte Zeilen
- Blame
- Diffs
- Status Line Integration
...

### mason.nvim

https://github.com/williamboman/mason.nvim

Installiert externe Dependendies (z.B. ruff, clangd, ...) automatisch

### mini.nvim

https://github.com/echasnovski/mini.nvim

Enthält viele kleine Module, siehe: https://github.com/echasnovski/mini.nvim?tab=readme-ov-file#modules

### nvim-lspconfig

https://github.com/neovim/nvim-lspconfig

Standard-Konfigurationen für diverse LSPs

### nvim-treesitter

https://tree-sitter.github.io/tree-sitter/
https://github.com/tree-sitter/tree-sitter

Treesitter ist ein Framework um Programmierspachen zu parsen. Dadurch werden Dinge wie Code Highlighting, Navigation, usw. möglich

### nvim-web-devicons

https://github.com/nvim-tree/nvim-web-devicons

Nerd Font Icons

### telescope.nvim

https://github.com/nvim-telescope/telescope.nvim

Framework zur Erstellung von Such-Funktionen. Kommt mit diversen Standardsuchen, z.B. Dateisuche.

### todo-comments.nvim

https://github.com/folke/todo-comments.nvim

Hervorhebung von ToDos. Kann mit Telescope durchsucht werden.

### vim-sleuth

https://github.com/tpope/vim-sleuth

Automatische Erkennung von Tab und Spaces

### which-key.nvim

https://github.com/folke/which-key.nvim

Blendet mögliche Tastenbelegungen ein.

### nvim-cmp

https://github.com/hrsh7th/nvim-cmp

Einblendungen für Autovervollständigungen. Die Vorschläge kommen aber von extern und müssen als Quellen eingebunden werden.

### luaSnip

https://github.com/L3MON4D3/LuaSnip

Verwaltet Code Snippets und fügt sie ein

### lazydev.nvim

https://github.com/folke/lazydev.nvim

Bessere LSP Konfiguration für lua

### conform.nvim

https://github.com/stevearc/conform.nvim

Autoformatter für so ziemlich alles

### neo-tree.vim

https://github.com/nvim-neo-tree/neo-tree.nvim

Zeigt einen Dateibaum (und andere Sachen als Baum) links an

### neogit

https://github.com/NeogitOrg/neogit

Verschiedene Git Funktionen wie Graph, Diffs, Stage, Stash, usw.

### nvim-dap

https://github.com/mfussenegger/nvim-dap

Anbindung von Debuggern per Debug Adapter Protocol

### nvim-dap-ui

https://github.com/rcarriga/nvim-dap-ui

GUI für nvim-dap

### overseer.nvim

https://github.com/stevearc/overseer.nvim

Tasks Verwaltung; kann VSCode tasks.json lesen

### nvim-notify

https://github.com/rcarriga/nvim-notify

Zeigt Benachrichtigungen an, z.B. wenn ein Task abgeschlossen ist

### nvim-window

https://github.com/yorickpeterse/nvim-window

Wechseln des aktiven Fensters durch Shortcut und Auswahl

### neoscroll.nvim

https://github.com/karb94/neoscroll.nvim

Scrollt mit einer Animation um Sprünge leichter sichtbar zu machen

### bufferline.nvim

https://github.com/akinsho/bufferline.nvim

Zeigt alle geöffneten Buffer als "Tabs" an

### auto-session

auto-session nvim

Speichert und öffnet die letzte Sitzung für einen Ordner

### nvim-treesitter-context

https://github.com/nvim-treesitter/nvim-treesitter-context

Zeigt ein "Sticky Scroll" oben im Editor an

### indent-blankline.nvim

https://github.com/lukas-reineke/indent-blankline.nvim

Zeigt Indent Level grafisch und bunt an.
