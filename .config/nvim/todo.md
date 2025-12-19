## Today
### Review
### Fixes
- use separate libs for mini
### New features
- go.nvim: config 
    - disable auto-configuring lsp, dap, cmp
- normal mode in cmd with preview and syntax highlighting
    - nvim-rip-substitute (check more plugins)
    - try use builtin `<C-F>`
- normal mode renaming (`<Space>rn`)
- mass replace (cdo) going backward/forward

## Fixes
### New features
- scroll animation
- performance profiler
- text editing through ssh
    - file editing through ssh and oil.nvim
### Keys
- multiple cursors on the similar word like emacs
- jump to error line in stack trace (terminal mode)
- ts-objects + surround: delete function declaration without body
- dadbod: keymap show previous request
- dadbod: foreignkey jump
### LSP
- better autocompletion with SQL LSP

## Plugins
- various-textobjects
    - better textobjects (than mini.ai)
    - replace mini.indent with it
- lazygit
- grug-far
- nvim-bqf
- quicker
    - better (modifiable) quickfix buffer
- avante
- mcphub
- flash
    - f highligh
    - / search indicator near the word 
- refactoring: https://github.com/ThePrimeagen/refactoring.nvim
- sniprun
    - run code snippets
### Not sure
- live-command
    - commandline macro (hope it will work in normal-cmdline-mode `<C-F>`)
- yanky
- scissors
    - easy snippet creation
- todo-comments
- Persistence
