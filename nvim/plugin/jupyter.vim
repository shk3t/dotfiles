"nnoremap <silent><expr> <Space>m  :MagmaEvaluateOperator<CR>
nnoremap <silent>       <Space>ml :MagmaEvaluateLine<CR>
xnoremap <silent>       <Space>m  m0:<C-U>MagmaEvaluateVisual<CR>:<C-U>keepjumps normal! `0<CR>
nnoremap <silent>       <Space>mr :MagmaReevaluateCell<CR>
nnoremap <silent>       <Space>md :MagmaDelete<CR>
nnoremap <silent>       <Space>mo :MagmaShowOutput<CR>
"nnoremap <silent>       <Space>ma ggVG:<C-U>MagmaEvaluateVisual<CR>

nnoremap <Space>Md :MagmaDeinit<CR>
nnoremap <Space>Mr :MagmaRestart<CR>
nnoremap <Space>Mq :MagmaInterrupt<CR>
nnoremap <Space>Ms :MagmaSave<CR>
nnoremap <Space>Ml :MagmaLoad<CR>

let g:magma_automatically_open_output = v:false
let g:magma_output_window_borders = v:false
let g:magma_image_provider = "ueberzug"

let g:jupytext_fmt = "py"
