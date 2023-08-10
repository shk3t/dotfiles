## IMPORTANT TODOS
### Later
- [ ] treesitter better text objects 
    - jump to class/function name, not keyword
    - https://github.com/chrisgrieser/nvim-various-textobjs
    - https://github.com/RRethy/nvim-treesitter-textsubjects

# TODOS
- [ ] local configs
- [ ] `:help` catch error on close
- [?] yank system buffer truncate last linebreak
- [-] auto signcolumn toggling delay
- [ ] Lazy.nvim reload configs: https://github.com/folke/lazy.nvim/issues/445
### Keys
- [-] cmd move caret backward wordwise
### Lsp
- [ ] clean imports
- [ ] rename file with references
- [ ] null-ls refactoring
- [ ] tsserver import wihtout whitespaces in braces
- [-] cmp replace only on confirm
- [-] duplicate entries for cmp-buffer (clangd, pylsp)
    - https://github.com/hrsh7th/nvim-cmp/issues/511#issuecomment-1063014008
- [-] `<C-D>`/`<C-U>` scroll quick doc
### Dap
- [ ] do not allow change scopes split buffer (if it is last used for example)
    - check dap-ui source code (try to find "builder" function)
- [ ] debug python libraries (breakpoint rejected)
- [-] hover without borders
### Telescope
- [ ] preview signcolumn (is it possible???)
- [ ] `<C-Q>` to add all telescope entries to QF if no selection
#### custom telescope pickers
- [ ] hunks run sync: https://github.com/lewis6991/gitsigns.nvim/issues/791
- [ ] git_status + delta: https://github.com/nvim-telescope/telescope.nvim/issues/605
### Appearance
- [ ] aerial icons
- [ ] nvim-tree icons
### Jupyter
- [ ] vscode + neovim
- [ ] fix magma: https://github.com/dccsillag/magma-nvim/issues/83
    - [ ] or try fork: https://github.com/WhiteBlackGoose/magma-nvim-goose
- [ ] jupynium: https://github.com/kiyoon/jupynium.nvim
### Explore
- [ ] terminal mode
- [ ] interesting telescope pickers
### Optimize
- [ ] remove unused builtin vim modules

<br>

## New plugins
### Features
- [-] highlight `f` jumps
- [ ] better visualblock mode
- [ ] yank history
- [ ] normal mode in cmd with preview and syntax highlighting
- [ ] better (modifiable) quickfix buffer
- [ ] swap lines
- [ ] dot-repeat preivous jump
- [ ] jump to error line in stack trace
- [?] bookmarks
### Instances
- [ ] copilot.lua
- [ ] grapple
- [ ] heirline
- [ ] nvim-bqf
- [ ] trouble
- [ ] zen-mode
- [ ] live-command
- [ ] neogit
- [ ] dadbod
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

<br>

## Global
- [ ] firefox better smooth scrolling
- [ ] restore tmux + nvim sessions
### KDE
- [ ] note widgets on desktop
- [ ] keep window decorations without titlebar
- [ ] highlight focused window frame

## Another software
- [ ] pbcopy
- [ ] Neovide
- [ ] lf

<br>

## ZSH
- [ ] OHMYZSH
- [ ] python venv custom prompt (https://github.com/tonyseek/oh-my-zsh-virtualenv-prompt)
- [ ] better plugin for git prompt
- [ ] command args on `<Tab>`
- [ ] tmux integration (`<C-H`, `<C-L`, ... mappings)
