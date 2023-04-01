nnoremap <buffer> <C-CR> :wa<CR>:exec
    \ '!gcc -lm' shellescape(@%, 1) '-o c.out
    \ && ./c.out
    \ && rm c.out'<CR>

nnoremap <buffer> <Space>D :wa<CR>:exec
    \ '!gcc -lm -g' shellescape(@%, 1) '-o c.out'<CR>

" -lm ???
