nnoremap <buffer> <C-CR> :wa<CR>:exec
    \ '!nasm -f elf64' shellescape(@%, 1) '-o asm.o
    \ && ld asm.o -o asm
    \ && ./asm
    \ && rm asm.o asm'<CR>

nnoremap <buffer> <space>D :wa<CR>:exec
    \ '!nasm -g -f elf64' shellescape(@%, 1) '-o asm.o
    \ && ld asm.o -o' shellescape(expand('%:r'), 1)
    \ '&& rm asm.o'<CR>
