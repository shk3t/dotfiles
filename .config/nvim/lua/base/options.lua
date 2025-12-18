-- Indents
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.cindent = true

-- Lines
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = true
vim.o.linebreak = true
vim.o.breakindent = true

-- Syntax highlighting
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

-- Appearance
vim.o.termguicolors = true
vim.o.background = "dark"
vim.o.cursorline = true
vim.o.cursorlineopt = "number"
vim.o.guicursor = "n-v-sm-t:block,i-c-ci-ve:ver25,r-cr-o:hor20"
vim.o.signcolumn = "yes"
vim.opt.shortmess:append("sS")
vim.o.showcmdloc = "statusline"
-- vim.opt.winborder = { "", "", "", " ", "", "", "", " " },  -- INFO: currently not supported

-- Controls
vim.o.timeoutlen = 10000
vim.o.mouse = "a"
vim.o.mousescroll = "ver:3,hor:12"
vim.opt.cpoptions:remove("_")

-- Buffer
vim.o.swapfile = false
vim.o.undofile = true

-- Explorer
vim.g.netrw_hide = 1
vim.g.netrw_list_hide = [[^\./$]]

-- Language
vim.o.keymap = "russian-jcukenwin"
vim.o.langmap =
  "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"
vim.o.iminsert = 0
vim.o.imsearch = -1

-- Spell
vim.o.spell = false
vim.o.spelllang = "en_us,ru_ru"
