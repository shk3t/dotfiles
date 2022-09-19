nnoremap <buffer> <space><CR> :wa<CR>:exec '!g++' shellescape(@%, 1) '&& ./a.out && rm a.out'<CR>
