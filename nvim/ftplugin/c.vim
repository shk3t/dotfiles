nnoremap <buffer> <space><CR> :wa<CR>:exec
    \ '!gcc' shellescape(@%, 1) '-o c.out
    \ && ./c.out
    \ && rm c.out'<CR>

nnoremap <buffer> <space>D :wa<CR>:exec
    \ '!gcc -g' shellescape(@%, 1) '-o c.out'<CR>
