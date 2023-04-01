nnoremap <buffer> <C-CR> :wa<CR>:exec '!python3' shellescape(@%, 1)<CR>
nnoremap <Space>Mi :MagmaInit python3<CR>

"lua <<EOF
"    require('nvim-treesitter.highlight').set_custom_captures {
"        ["variable.builtin"] = "",
"        ["constant.builtin"] = "",
"        ["type.builtin"] = "",
"    }
"EOF
