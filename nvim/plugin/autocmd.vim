function! RelativeNumberOn() abort
    if &number == 1
        set relativenumber
        "redraw
    endif
endfunction


" No autocomments
autocmd FileType * setlocal formatoptions-=o

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

" Tmux
" if exists('$TMUX')
"     autocmd BufEnter * call system("tmux rename-window '" . expand("%:t") . "'")
"     autocmd VimLeave * call system("tmux setw automatic-rename")
" endif

" autocmd!
" autocmd BufWritePre * %s/\s\+$//e
