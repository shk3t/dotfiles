" AUTOCMD
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

autocmd VimEnter * silent !echo -ne "\e[2 q"

autocmd FocusLost,WinLeave * set norelativenumber
autocmd FocusGained,WinEnter,BufEnter * if &number == 1 | set relativenumber | endif
autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif
autocmd FileType * setlocal formatoptions+=r formatoptions-=co
autocmd FileType markdown setlocal formatoptions-=r
autocmd CmdwinEnter * nnoremap <buffer><silent> q :q<CR>
autocmd FileType help nnoremap <buffer><silent> q :q<CR>


" KEYMAPS
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
noremap <C-C> <Esc>
inoremap <C-C> <Esc>
inoremap <C-Del> <C-O>de
inoremap <C-V> <C-R>"
cnoremap <C-V> <C-R>"
vnoremap D "_d
vnoremap C "_c
vnoremap P "0p
vnoremap $ g_
nnoremap <silent> <expr> J "<Cmd>let p=getpos('.')<Bar>join " . (v:count1 + 1) . "<Bar>call setpos('.', p)<CR>"
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
noremap <C-D> <C-D>zz
noremap <C-U> <C-U>zz
noremap <C-O> <C-O>zz
noremap <C-I> <C-I>zz
noremap <expr> n 'Nn'[v:searchforward] . 'zz'
noremap <expr> N 'nN'[v:searchforward] . 'zz'
noremap # #zz
noremap * *zz
cnoremap <C-J> <C-N>
cnoremap <C-K> <C-P>
noremap <C-S-C> "+y
noremap <M-Left> <C-O>
noremap <M-Right> <C-I>
noremap - ^
noremap <BS> s
noremap <C-Z> <Nop>
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
noremap <C-W>s <C-W>s<C-W>j
noremap <C-W>v <C-W>v<C-W>l
noremap <C-W><C-S> <C-W>s<C-W>j
noremap <C-W><C-V> <C-W>v<C-W>l
noremap <C-H> <C-W>h
noremap <C-J> <C-W>j
noremap <C-K> <C-W>k
noremap <C-L> <C-W>l
noremap <Tab> <C-6>
noremap <C-W>f <Cmd>copen<CR>
noremap <C-W><C-F> <Cmd>copen<CR>
noremap <C-Q> <C-W>q
noremap <C-W>; <C-W>p
noremap <silent> <C-S> :<C-U>write<CR>
inoremap <silent> <C-S> <C-O>:<C-U>write<CR>
noremap <C-W>c <C-W><Esc>
noremap <C-W><C-c> <C-W><Esc>
noremap <silent> <C-W>t <C-W>v<C-W>T
noremap <silent> <C-W>, <Cmd>tabprevious<CR>
noremap <silent> <C-W>. <Cmd>tabnext<CR>
for i in range(1, 9)
    execute 'noremap <silent> <C-W>'.i.' <Cmd>'.i.'tabnext<CR>'
    execute 'noremap <silent> <Space>'.i.' <Cmd>'.i.'tabnext<CR>'
endfor
noremap <silent> <C-W>< <Cmd>-tabmove<CR>
noremap <silent> <C-W>> <Cmd>+tabmove<CR>
noremap <silent> <C-W>Q <Cmd>tabclose<CR>
noremap <silent> <C-W><C-T> <C-W>v<C-W>T
noremap <silent> <C-W><C-,> <Cmd>tabprevious<CR>
noremap <silent> <C-W><C-.> <Cmd>tabnext<CR>
noremap <silent> <S-Tab> g<Tab>
nnoremap <silent> } :<C-U>execute "keepjumps normal! " . v:count1 . "}"<CR>
nnoremap <silent> { :<C-U>execute "keepjumps normal! " . v:count1 . "{"<CR>
nnoremap <expr> k (v:count > 1 ? "m'" . v:count . 'k' : 'gk')
nnoremap <expr> j (v:count > 1 ? "m'" . v:count . 'j' : 'gj')
vnoremap k gk
vnoremap j gj


" OPTIONS
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set cinoptions=g0,(0,Ws,l,L0
set number
set relativenumber
set scrolloff=8
set wrap
set linebreak
set breakindent
syntax on
set hlsearch
set incsearch
set ignorecase
set smartcase
set completeopt=menu,menuone,noselect
set background=dark
set cursorline
set cursorlineopt=number,line
set guicursor=n-v-sm:block,i-c-ci-ve:ver25,r-cr-o:hor20
set timeoutlen=10000
set mouse=a
set cpoptions-=_
set noerrorbells
set novisualbell
set hidden
set noswapfile
set nobackup
set undofile
set undodir=~/.local/share/vim/undo/
set updatetime=500
let g:netrw_list_hide = '^\./$'
let g:netrw_hide = 1
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
