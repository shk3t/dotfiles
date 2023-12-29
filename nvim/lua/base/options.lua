-- Taboptions
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.cinoptions = "g0,(0,Ws,l,L0"

-- Lines
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true

-- Syntax highlighting
vim.cmd.syntax("on")
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.completeopt = {"menu", "menuone", "noselect"}

-- Appearance
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.cursorline = true
-- vim.opt.cursorlineopt = {"number", "line"}
vim.opt.cursorlineopt = {"number"}
vim.opt.guicursor = "n-v-sm:block,i-c-ci-ve:ver25,r-cr-o:hor20"
vim.opt.signcolumn = "yes"

-- Controls
vim.opt.timeoutlen = 10000
vim.opt.mouse = "a"
vim.cmd("set cpoptions-=_")

-- Sounds
vim.opt.errorbells = false
vim.opt.visualbell = false

-- Buffer
vim.opt.hidden = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.updatetime = 200
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo/"
vim.opt.undofile = true
vim.opt.shadafile = vim.fn.stdpath("data") .. "/shadas/" .. vim.fn.getcwd():gsub("/", "%%")

-- Navigation
-- vim.opt.jumpoptions = "stack"

-- Explorer
vim.g.netrw_list_hide = [[^\./$]]
vim.g.netrw_hide = 1
-- let b:netrw_lastfile = 1

-- Language
vim.g.XkbSwitchEnabled = 1
vim.g.XkbSwitchAssistNKeymap = 0 -- for commands r and f
vim.g.XkbSwitchNLayout = "us" -- better telescope support
-- vim.g.XkbSwitchIminsertToggleKey = '<C-^>'
vim.opt.keymap = "russian-jcukenwin"
vim.opt.iminsert = 0
vim.opt.imsearch = -1
vim.opt.langmap = "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"
