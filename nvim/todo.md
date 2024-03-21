## IMPORTANT TODOS

### First
- [ ] graptql lsp: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#graphql
- [ ] HTTP client instead of Insomnia (https://github.com/rest-nvim/rest.nvim)
- [ ] discord presence: https://github.com/andweeb/presence.nvim
- [ ] horizontal scroll not focused window
- [ ] jump to error line in stack trace
- [ ] treesitter better text objects 
    - https://github.com/nvim-treaesitter/nvim-treesitter-textobjects
    - https://github.com/RRethy/nvim-treesitter-textsubjects
    - https://github.com/chrisgrieser/nvim-various-textobjs
    - https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-ai.md
    - https://neovim.discourse.group/t/autocmd-to-keep-cursor-position-on-yank/2982/2
    - [ ] Features
        - `q` to select any quote
        - jump to class/function name, not keyword
        - dot-repeat
        - correct lua function
        - key, value, triple quotes
        - fast increment-decrement node selections
- [ ] better autocompletion with SQL LSP
- [ ] neogit
- [ ] better xkbswitch: https://github.com/ivanesmantovich/xkbswitch.nvim
- [ ] jupyter: https://github.com/kiyoon/jupynium.nvim
    - [ ] iron: jupyter support: https://www.maxwellrules.com/misc/nvim_jupyter.html
    - [ ] nvim-ipy: https://github.com/bfredl/nvim-ipy
    - [ ] molten-nvim migration: https://github.com/benlubas/molten-nvim
- [ ] git status delta: https://github.com/nvim-telescope/telescope.nvim/issues/605

# TODOS
- [ ] text editing through ssh
- [ ] command line rename (:s) autocomplete
### Keys
- [ ] visual dot-repeat
### Dap
- [-] hover without borders
- [ ] js/ts debugger
### Telescope
- [ ] `<C-Q>` to add all telescope entries to QF if no selection
    - [ ] fast global rename
### Explore
- [ ] terminal mode
- [ ] interesting telescope pickers
### Optimize
- [ ] remove unused builtin vim modules

<br>

## Plugins
### Waiting for update
- Lazy.nvim reload configs: https://github.com/folke/lazy.nvim/issues/445
- cmp replace only on confirm
- duplicate entries for cmp-buffer (clangd, pylsp)
    - https://github.com/hrsh7th/nvim-cmp/issues/511#issuecomment-1063014008
- `<C-D>`/`<C-U>` scroll quick doc
- spider russian language support
- git hunks run sync: https://github.com/lewis6991/gitsigns.nvim/issues/791
- rename file with lsp references: https://github.com/neovim/neovim/issues/20784
- magma proper save/load, export to `.ipynb`
- telescope mouse support: https://github.com/nvim-telescope/telescope.nvim/issues/2213
- pyright autoimport relative
### Features
- [ ] yank history
- [-] highlight `f` jumps
- [ ] better visualblock mode
- [ ] normal mode in cmd with preview and syntax highlighting
- [ ] better (modifiable) quickfix buffer
- [ ] swap lines
- [ ] dot-repeat previous jump
- [?] bookmarks
### Instances
- [ ] refactoring: https://github.com/ThePrimeagen/refactoring.nvim
- [ ] typescript utils:
    - https://github.com/jose-elias-alvarez/typescript.nvim
    - https://github.com/pmizio/typescript-tools.nvim
- [ ] copilot.lua
- [ ] heirline
- [ ] nvim-bqf
- [ ] trouble
- [ ] zen-mode
- [ ] live-command
- [ ] mini.ai
- [ ] unimpaired
- [ ] telescope filebrowser
- [ ] nvim-hlslens
- [ ] nvim-treesitter-refactor
- [ ] neoscroll / cinnamon
- [ ] lspsaga
- [ ] neoclip
- [ ] neorg
- [ ] nvim-ufo (folding)
- [ ] hop / leap / flash
- [ ] whichkey
- [ ] lazygit (integration)
- [ ] ssr

<br>

## Global
- [ ] CHEATSH: https://github.com/chubin/cheat.sh
- [ ] openvpn
- [ ] restore tmux + nvim sessions
### ZSH
- [ ] pass keys to zsh via tmux (like vim)
    - [ ] optimize vim passing (regex)
- [ ] zsh suggest prediction (`cd` e.g.)
### KDE
- [ ] note widgets on desktop

## Another software
- [ ] pbcopy
- [ ] lf
