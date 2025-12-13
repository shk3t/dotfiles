## Today
### Review
- cmp
- debug
- navigation
- integrations
- ui
- tweaks
### Fixes
- nvim spider extend support for cyrillic symbols
- `p` paste always preserves previous yank (swap with current `P`)
- cmp replace only on confirm
- command line substitute (:s) autocomplete
### New plugins
- mini.surround vs nvim-surround
    - check loading time
- mini.comment vs Comment.nvim
- blink.cmp
- recursive renaming with neo-tree
    - rename file with lsp references: https://github.com/neovim/neovim/issues/20784
    - https://github.com/folke/snacks.nvim/blob/main/docs/rename.md
### New features
- config go.nvim
- mass replace (cdo) going backward/forward

## Fixes
### New features
- normal mode in cmd with preview and syntax highlighting
- text editing through ssh
- lazygit integration
- performance profiler
### Keys
- multiple cursors on the similar word like emacs
- jump to error line in stack trace (terminal mode)
### LSP
- better autocompletion with SQL LSP

## Plugins
- harpoon
    - Easy peasy navigation
- avante
    - AI
- mcphub
    - mcp integration
- refactoring: https://github.com/ThePrimeagen/refactoring.nvim
- trouble
    - show definition, references, diagnostics in one window
- mini.ai
    - selecting outer brackets
- sniprun
    - run code snippets
- flash
    - f highligh
    - / search indicator near the word 
- nvim-bqf
    - better (modifiable) quickfix buffer
