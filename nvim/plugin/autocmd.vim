function! RelativeNumberOn() abort
    if &number == 1
        set relativenumber
        "redraw
    endif
endfunction
" Line numeration toggle
"autocmd FocusLost,WinLeave,CmdlineEnter * set norelativenumber | redraw
"autocmd FocusGained,WinEnter,CmdlineLeave,BufEnter * call RelativeNumberOn()
autocmd FocusLost,WinLeave * set norelativenumber
autocmd FocusGained,WinEnter,BufEnter * call RelativeNumberOn()

" Highlight yank
autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 100})

" Yank preserve cursor position
autocmd VimEnter,CursorMoved *
        \ let s:cursor = getpos('.')
autocmd TextYankPost *
    \ if v:event.operator ==? 'y' |
        \ call setpos('.', s:cursor) |
    \ endif

" Open in specific split
autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif

" Trim trailing spaces
"autocmd BufWritePre * %s/\s\+$//e

" Set the filetype based on the file's extension
autocmd BufRead,BufNewFile *.inc setlocal filetype=asm
" autocmd BufRead,BufNewFile *.h setlocal filetype=c

" Don't add the comment prefix when I hit o/O on a comment line.
autocmd FileType * setlocal formatoptions+=r formatoptions-=co
autocmd FileType markdown setlocal formatoptions-=r

" Cursor line highlighting
autocmd FileType aerial setlocal cursorlineopt=line
autocmd FileType netrw setlocal cursorlineopt=line

" Easy Window closing
autocmd CmdwinEnter * nnoremap <buffer><silent> q :q<CR>
autocmd FileType help nnoremap <buffer><silent> q :q<CR>
autocmd FileType dap-float nnoremap <buffer><silent> q :q<CR>

" Other
" TODO: use lua
autocmd User TelescopePreviewerLoaded setlocal number | setlocal wrap
autocmd FileType dap-repl
    \ inoremap <buffer><silent> <C-K> <C-W>k |
    \ inoremap <buffer><silent> <C-L> <C-W>l |
    \ imap <buffer><silent> <C-P> <Up><End> |
    \ imap <buffer><silent> <C-N> <Down><End> |

" autocmd CursorHold * lua vim.diagnostic.open_float({scope="line"})
" autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()
