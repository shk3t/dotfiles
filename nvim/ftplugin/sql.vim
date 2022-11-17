nnoremap <buffer> <space><CR> :wa<CR>:exec
    \ '!psql -f' shellescape(@%, 1)<CR>
