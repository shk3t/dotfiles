" SETS
" Tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set cinoptions=g0,(0,Ws,l,L0
" set cinoptions=:0,g0,(0,Ws,l,L0

" Lines
set number
set relativenumber
set signcolumn=yes
set scrolloff=8
set nowrap
set linebreak
set breakindent
"set showbreak=..

" Syntax highlighting
set hlsearch
set incsearch
set ignorecase
set smartcase
syntax on
set completeopt=menu,menuone,noselect
"set foldmethod=expr set foldexpr=nvim_treesitter#foldexpr()

" Sounds
set noerrorbells
set novisualbell

" Buffer
set hidden
set noswapfile
set nobackup
set undofile
set undodir=~/.local/share/nvim/undo/
set updatetime=500

" Navigation
set jumpoptions=stack

" Explorer
let g:netrw_list_hide = '^\./$'
let g:netrw_hide = 1
"let b:netrw_lastfile = 1
"let g:netrw_liststyle = 3  " Tree-like explorer

" Language
let g:XkbSwitchEnabled = 1
let g:XkbSwitchAssistNKeymap = 1  " for commands r and f
let g:XkbSwitchNLayout = 'us' " better telescope support
"let g:XkbSwitchIminsertToggleKey = '<C-^>'
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
"set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

" Providers
let g:loaded_perl_provider = 0
