" Settings
set timeoutlen=10000
set mouse=a
set cpoptions-=_

" functions
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
" function! RExplore() abort
"     if exists("w:netrw_rexlocal")
"         Rexplore
"     else
"         Explore
"     endif
" endfunction

" Commands
command! Cdc cd %:p:h

" Default behaviour
noremap <C-C> <Esc>
inoremap <C-C> <Esc>
inoremap <C-H> <C-W>
cnoremap <C-H> <C-W>
inoremap <C-Del> <Esc><Right>dei
inoremap <C-V> <C-R>"
noremap <C-L> <Nop>
noremap p p`]
noremap P P`]
vnoremap D "_d
vnoremap P "0p`]
vnoremap $ g_
"nnoremap <silent> J :<C-U>execute "join ".(v:count1 + 1)<CR>
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
"noremap <C-D> <C-D>zz
"noremap <C-U> <C-U>zz
noremap n nzz
noremap N Nzz
noremap * *zz
noremap # ##*zz
cnoremap <C-J> <C-N>
cnoremap <C-K> <C-P>
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
noremap <C-S-c> "+y

" <Space> mappings
noremap <Space> <Nop>
inoremap <C-Space> <Nop>
noremap <Space>y "+y
noremap <Space>Y :%y+<CR>
"noremap <Space>d "_d
"vnoremap <Space>p "_dP`]
noremap <Space>? :set hlsearch!<CR>
noremap <Space>C :set ignorecase!<CR>
"noremap <Space>V :set cursorcolumn!<CR>
noremap <Space>N :call ToggleLineNumeration()<CR>
noremap <Space>I :call ToggleTabWidth()<CR>
noremap <Space>W :call ToggleLineWrap()<CR>
nnoremap <Space>/s :%s/\<<C-R><C-W>\>//g<Left><Left>
vnoremap <Space>/s "0yV:s/\<<C-R>0\>//g<Left><Left>
nnoremap <silent> <Space>e :Explore<CR>
" nnoremap <silent> <Space>e :call RExplore()<CR>
nnoremap <Space>Lr :LspRestart<CR>
nnoremap <Space>Li :LspInfo<CR>
nnoremap <Space>dm :delmarks a-zA-Z0-9<CR>

" Splits
noremap <C-W>s <C-W>s<C-W>j
noremap <C-W>v <C-W>v<C-W>l

" Tabs
noremap <C-W>c <C-W><esc>
noremap <C-W><C-c> <C-W><esc>
" noremap <silent> <C-W>t :tablast \| tabnew .<CR>
" noremap <silent> <C-W>t :tabnew .<CR>
noremap <silent> <C-W>t <C-W>v<C-W>T
" noremap <silent> <C-W>t <C-W>v<C-W>T \| tabmove<CR>
noremap <silent> <C-W>, :tabprevious<CR>
noremap <silent> <C-W>. :tabnext<CR>
for i in range(1, 9)
    execute 'noremap <silent> <C-W>'.i.' :'.i.'tabnext<CR>'
endfor
noremap <silent> <C-W>< :-tabmove<CR>
noremap <silent> <C-W>> :+tabmove<CR>
noremap <silent> <C-W>Q :tabclose<CR>
noremap <C-W>n :TabRename 

" Jumplist
" nnoremap <silent> } :<C-u>execute "keepjumps normal! " . v:count1 . "}"<CR>
" nnoremap <silent> { :<C-u>execute "keepjumps normal! " . v:count1 . "{"<CR>
nnoremap <expr> k (v:count > 1 ? "m'" . v:count . 'k' : 'gk')
nnoremap <expr> j (v:count > 1 ? "m'" . v:count . 'j' : 'gj')
vnoremap k gk
vnoremap j gj

" Custom jumps
nnoremap <silent> [i m':call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%<' . line('.') . 'l\S', 'be')<CR>
nnoremap <silent> ]i m':call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%>' . line('.') . 'l\S', 'e')<CR>

" Snippets
snoremap <BS> _<C-W>
snoremap <C-C> <Esc>
snoremap p p

" Sql
let g:ftplugin_sql_omni_key = '<C-S>'
