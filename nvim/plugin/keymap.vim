" Settings
set timeoutlen=10000
set mouse=a
set cpoptions-=_

" functions
function! SwitchLineNumeration() abort
    if &number == 1
        set norelativenumber
        set nonumber
    else
        set relativenumber
        set number
    endif
endfunction

" Commands
command! Cdc cd %:p:h

" Default behaviour
noremap <C-C> <Esc>
inoremap <C-C> <Esc>
inoremap <C-H> <C-W>
cnoremap <C-H> <C-W>
inoremap <C-Del> <Esc><Right>dei
noremap <C-L> <Nop>
noremap p p`]
noremap P P`]
"vnoremap p "0p`]
vnoremap P "_dP`]
vnoremap $ g_
"nnoremap <silent> J :<C-U>execute "join ".(v:count1 + 1)<CR>
"vnoremap J :m '>+1<CR>gv=gv
"vnoremap K :m '<-2<CR>gv=gv
noremap <C-D> <C-D>zz
noremap <C-U> <C-U>zz
"noremap n nzzzv
"noremap N Nzzzv
"noremap * *zzzv
"noremap # #zzzv
cnoremap <C-J> <C-N>
cnoremap <C-K> <C-P>
nnoremap ya" y2i"
nnoremap da" d2i"
nnoremap ya" y2i"
nnoremap ya' y2i'
nnoremap da' d2i'
nnoremap ca' c2i'
nnoremap ya` y2i`
nnoremap da` d2i`
nnoremap ca` c2i`

" <Space> mappings
noremap <Space> <Nop>
noremap <Space>y "+y
noremap <Space>Y :%y+<CR>
"noremap <Space>d "_d
"vnoremap <Space>p "_dP`]
noremap <Space>? :set hlsearch!<CR>
noremap <Space>I :set ignorecase!<CR>
noremap <Space>V :set cursorcolumn!<CR>
noremap <Space>N :call SwitchLineNumeration()<CR>
nnoremap <Space>s :%s/<C-R><C-W>//g<Left><Left>
vnoremap <Space>s "0yV:s/<C-R>0//g<Left><Left>
nnoremap <silent> <Space>e :Explore<CR>
" nnoremap <Space>Lr :LspRestart<CR>
" nnoremap <Space>Li :LspInfo<CR>

" Splits
noremap <C-W>s <C-W>s<C-W>j
noremap <C-W>v <C-W>v<C-W>l

" Tabs
noremap <C-W>c <C-W><esc>
noremap <C-W><C-c> <C-W><esc>
"noremap <silent> <C-W>t :tablast \| tabnew .<CR>
"noremap <silent> <C-W>t :tabnew .<CR>
noremap <silent> <C-W>t <C-W>v<C-W>T
noremap <silent> <C-W>, :tabprevious<CR>
noremap <silent> <C-W>. :tabnext<CR>
for i in range(1, 9)
   execute 'noremap <silent> <C-W>'.i.' :'.i.'tabnext<CR>'
endfor
noremap <silent> <C-W>< :-tabmove<CR>
noremap <silent> <C-W>> :+tabmove<CR>
noremap <silent> <C-W>Q :tabclose<CR>

" Jumplist
"nnoremap <silent> } :<C-u>execute "keepjumps normal! " . v:count1 . "}"<CR>
"nnoremap <silent> { :<C-u>execute "keepjumps normal! " . v:count1 . "{"<CR>
nnoremap <expr> k (v:count > 1 ? "m'" . v:count : '') . 'k'
nnoremap <expr> j (v:count > 1 ? "m'" . v:count : '') . 'j'

" TODO find the way how to generalize code with lua
" function! ShiftLeftRestore(type, ...) abort
"     if a:type == 'line'
"         keepjumps normal! '[<']
"     else
"         keepjumps normal! `[<`]
"     endif
"     call setpos('.', g:cursor)
" endfunction
" function! ShiftRightRestore(type, ...) abort
"     if a:type == 'line'
"         keepjumps normal! '[>']
"     else
"         keepjumps normal! `[>`]
"     endif
"     call setpos('.', g:cursor)
" endfunction
" nnoremap <silent> < :let g:cursor=getpos('.')<Bar>set opfunc=ShiftLeftRestore<CR>g@
" nnoremap <silent> > :let g:cursor=getpos('.')<Bar>set opfunc=ShiftRightRestore<CR>g@
" nmap << <<
" nmap >> >>
" vnoremap < <gv<Esc>
" vnoremap > >gv<Esc>
"

" Snippets
snoremap <BS> _<C-W>

" Sql
let g:ftplugin_sql_omni_key = '<C-S>'
