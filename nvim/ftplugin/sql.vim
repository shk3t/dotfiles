nnoremap <buffer> <C-CR> :wa<CR>:exec
    \ '!psql -f' shellescape(@%, 1)<CR>
