" AUTOCMD
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

autocmd VimEnter * silent !echo -ne "\e[2 q"
autocmd VimEnter,CursorMoved *
        \ let s:cursor = getpos('.')
autocmd TextYankPost *
    \ if v:event.operator ==? 'y' |
        \ call setpos('.', s:cursor) |
        \ echo 'yanked' |
    \ endif


" KEYMAPS
set timeoutlen=10000
set mouse=a
set cpoptions-=_

noremap <C-C> <Esc>
inoremap <C-C> <Esc>
inoremap <C-H> <C-W>
cnoremap <C-H> <C-W>
inoremap <C-Del> <Esc><Right>dei
noremap <C-L> <Nop>
noremap p p`]
noremap P P`]
vnoremap P "_dP`]
vnoremap $ g_
noremap <C-D> <C-D>zz
noremap <C-U> <C-U>zz
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
noremap <Space> <Nop>
noremap <Space>? :set hlsearch!<CR>
noremap <Space>I :set ignorecase!<CR>
nnoremap <Space>s :%s/<C-R><C-W>//g<Left><Left>
vnoremap <Space>s "0yV:s/<C-R>0//g<Left><Left>
nnoremap <silent> <Space>e :Explore<CR>
noremap <C-W>s <C-W>s<C-W>j
noremap <C-W>v <C-W>v<C-W>l
noremap <C-W>c <C-W><esc>
noremap <C-W><C-c> <C-W><esc>
noremap <silent> <C-W>t <C-W>v<C-W>T
noremap <silent> <C-W>, :tabprevious<CR>
noremap <silent> <C-W>. :tabnext<CR>
for i in range(1, 9)
   execute 'noremap <silent> <C-W>'.i.' :'.i.'tabnext<CR>'
endfor
noremap <silent> <C-W>< :-tabmove<CR>
noremap <silent> <C-W>> :+tabmove<CR>
noremap <silent> <C-W>Q :tabclose<CR>
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
set nowrap
set hlsearch
set incsearch
set ignorecase
set smartcase
syntax on
set completeopt=menu,menuone,noselect
set noerrorbells
set novisualbell
set hidden
set noswapfile
set nobackup
set undofile
set undodir=~/.local/share/nvim/undo/
set updatetime=500
let g:netrw_list_hide = '^\./$'
let g:netrw_hide = 1
