nnoremap <buffer> <C-CR> :wa<CR>:exec '!lua' shellescape(@%, 1)<CR>
setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
