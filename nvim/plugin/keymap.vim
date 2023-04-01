" Settings
set timeoutlen=10000
set mouse=a
set cpoptions-=_

" FUNCTIONS
function! ToggleLineNumeration() abort
    if &number == 1
        set norelativenumber
        set nonumber
    else
        set relativenumber
        set number
    endif
endfunction
function! ToggleTabWidth() abort
    if &shiftwidth != 4
        set tabstop=4
        set softtabstop=4
        set shiftwidth=4
    else
        set tabstop=2
        set softtabstop=2
        set shiftwidth=2
    endif
endfunction
function! ToggleLineWrap() abort
    if &wrap == 0
        set wrap
    else
        set nowrap
    endif
endfunction

" Commands
command! Cdc cd %:p:h

" Default behaviour
noremap <C-C> <Esc>
inoremap <C-C> <Esc>
inoremap <C-Del> <C-O>de
inoremap <C-V> <C-R>"
cnoremap <C-V> <C-R>"
noremap p p`]
noremap P P`]
vnoremap D "_d
vnoremap C "_c
vnoremap P "0p`]
vnoremap $ g_
nnoremap <silent> <expr> J "<Cmd>let p=getpos('.')<Bar>join " . (v:count1 + 1) . "<Bar>call setpos('.', p)<CR>"
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
noremap <C-D> <C-D>zz
noremap <C-U> <C-U>zz
noremap <C-O> <C-O>zz
noremap <C-I> <C-I>zz
noremap n nzz
noremap N Nzz
noremap * *zz
noremap <silent> # <Cmd>let @/= '\<' . expand('<cword>') . '\>'<CR><Cmd>set hlsearch<CR>viwo<Esc>
noremap <silent> ? <Cmd>let @/ = input('/')<CR><Cmd>set hlsearch<CR>
cnoremap <C-J> <C-N>
cnoremap <C-K> <C-P>
noremap <C-S-C> "+y
noremap <M-Left> <C-O>
noremap <M-Right> <C-I>
noremap <C-B> <C-V>
noremap - ^
noremap <BS> s

" Text objects
nnoremap va" v2i"
nnoremap ya" y2i"
nnoremap da" d2i"
nnoremap ca" c2i"
nnoremap va' v2i'
nnoremap ya' y2i'
nnoremap da' d2i'
nnoremap ca' c2i'
nnoremap va` v2i`
nnoremap ya` y2i`
nnoremap da` d2i`
nnoremap ca` c2i`

" Space mappings
noremap <Space> <Nop>
inoremap <C-Space> <Nop>
noremap <Space>y "+y
noremap <Space>Y :%y+<CR>
noremap <Space>? <Cmd>set hlsearch!<CR>
noremap <Space>C <Cmd>set ignorecase!<CR>
noremap <Space>N <Cmd>call ToggleLineNumeration()<CR>
noremap <Space>I <Cmd>call ToggleTabWidth()<CR>
noremap <Space>W <Cmd>call ToggleLineWrap()<CR>
nnoremap <Space>/s :s/\<<C-R><C-W>\>//g<Left><Left>
nnoremap <silent> <Space>e <Cmd>Explore<CR>
" nnoremap <silent> <Space>e <Cmd>call RExplore()<CR>
noremap <Space>LR <Cmd>LspRestart<CR>
noremap <Space>LI <Cmd>LspInfo<CR>
" nnoremap <Space>dm <Cmd>delmarks a-zA-Z0-9<CR>

" Splits
noremap <C-W>s <C-W>s<C-W>j
noremap <C-W>v <C-W>v<C-W>l
noremap <C-W><C-S> <C-W>s<C-W>j
noremap <C-W><C-V> <C-W>v<C-W>l
noremap <C-W>f <Cmd>copen<CR>
noremap <C-W><C-F> <Cmd>copen<CR>

" Fast actions
"noremap <C-S> <C-W>s<C-W>j
"noremap <C-Z> <C-W>s<C-W>j
noremap <C-V> <C-W>v<C-W>l
noremap <C-Q> <C-W>q
noremap <C-W>; <C-W>p
noremap <silent> <C-S> :<C-U>write<CR>
"noremap <silent> <C-T> <C-W>v<C-W>T

" Tabs
noremap <C-W>c <C-W><Esc>
noremap <C-W><C-c> <C-W><Esc>
noremap <silent> <C-W>t <C-W>v<C-W>T
" noremap <silent> <C-W>t <C-W>v<C-W>T \| tabmove<CR>
noremap <silent> <C-W>, <Cmd>tabprevious<CR>
noremap <silent> <C-W>. <Cmd>tabnext<CR>
for i in range(1, 9)
    execute 'noremap <silent> <C-W>'.i.' <Cmd>'.i.'tabnext<CR>'
    execute 'noremap <silent> <Space>'.i.' <Cmd>'.i.'tabnext<CR>'
endfor
noremap <silent> <C-W>< <Cmd>-tabmove<CR>
noremap <silent> <C-W>> <Cmd>+tabmove<CR>
noremap <silent> <C-W>Q <Cmd>tabclose<CR>
noremap <C-W>n :<C-U>TabRename 
noremap <silent> <C-W><C-T> <C-W>v<C-W>T
noremap <silent> <C-W><C-,> <Cmd>tabprevious<CR>
noremap <silent> <C-W><C-.> <Cmd>tabnext<CR>
noremap <C-W><C-N> :<C-U>TabRename 

" Jumplist
nnoremap <silent> } :<C-U>execute "keepjumps normal! " . v:count1 . "}"<CR>
nnoremap <silent> { :<C-U>execute "keepjumps normal! " . v:count1 . "{"<CR>
nnoremap <expr> k (v:count > 1 ? "m'" . v:count . 'k' : 'gk')
nnoremap <expr> j (v:count > 1 ? "m'" . v:count . 'j' : 'gj')
vnoremap k gk
vnoremap j gj

" Custom jumps
"nnoremap <silent> [i m'<Cmd>call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%<' . line('.') . 'l\S', 'be')<CR>
"nnoremap <silent> ]i m'<Cmd>call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%>' . line('.') . 'l\S', 'e')<CR>

" Snippets
snoremap <BS> _<C-W>
snoremap <C-C> <Esc>
snoremap p p

" Sql
let g:ftplugin_sql_omni_key = '<C-H-S>'

" Tmux integration
noremap <C-H> <Cmd>lua require("tmux").move_left()<CR>
noremap <C-J> <Cmd>lua require("tmux").move_bottom()<CR>
noremap <C-K> <Cmd>lua require("tmux").move_top()<CR>
noremap <C-L> <Cmd>lua require("tmux").move_right()<CR>
noremap <C-S-H> <Cmd>lua require("tmux").resize_left()<CR>
noremap <C-S-J> <Cmd>lua require("tmux").resize_bottom()<CR>
noremap <C-S-K> <Cmd>lua require("tmux").resize_top()<CR>
noremap <C-S-L> <Cmd>lua require("tmux").resize_right()<CR>

" Bugfix
" noremap <M-Tab> <C-I>zz " tmux
