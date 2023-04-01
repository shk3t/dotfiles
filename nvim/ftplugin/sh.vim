nnoremap <buffer> <C-CR> :wa<CR>:exec '!bash' shellescape(@%, 1)<CR>
