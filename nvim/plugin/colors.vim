set background=dark
set cursorline
set cursorlineopt=number
set guicursor=n-v-sm:block,i-c-ci-ve:ver25,r-cr-o:hor20

let g:tokyonight_style = "night"
let g:catppuccin_flavour = "mocha"

colorscheme tokyonight

fun! ConfigColors()
    hi CurSearch guibg=None guifg=None
    hi CursorLineNr gui=bold
endfun

fun! SetWideBorder()
    let vertsplit_guifg = synIDattr(synIDtrans(hlID('VertSplit')), 'fg')
    execute "hi VertSplit guibg=" . vertsplit_guifg
endfun

fun! SetTransparentBG()
    hi Normal guibg=None
    hi NormalNC guibg=None
    hi NonText guibg=None
    hi LineNr guibg=None
    hi SignColumn guibg=None
    hi TabLineFill guibg=None
    hi TabLine guibg=None
    "hi EndOfBuffer guibg=None
    set pumblend=20
    hi PmenuSel blend=0
    hi NormalFloat blend=20
endfun

autocmd SourcePost,Colorscheme * call ConfigColors()
autocmd SourcePost,Colorscheme * call SetWideBorder()
autocmd SourcePost,Colorscheme * call SetTransparentBG()
