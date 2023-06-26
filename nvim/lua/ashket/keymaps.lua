local keymap = vim.keymap.set

local function toggle_line_numeration()
  vim.opt.number = not vim.o.number
  vim.opt.relativenumber = vim.o.number
end
local function toggle_tab_width()
  vim.opt.shiftwidth = vim.o.shiftwidth == 4 and 2 or 4
  vim.opt.tabstop = vim.o.shiftwidth
  vim.opt.softtabstop = vim.o.shiftwidth
end
local function toggle_line_wrap() vim.opt.wrap = not vim.o.wrap end

-- Commands
vim.cmd([[command! Cdc cd %:p:h]])

-- Default behaviour
keymap({"n", "v"}, "<C-C>", "<Esc>")
keymap("i", "<C-C>", "<Esc>")
keymap("i", "<C-Del>", "<C-O>de")
keymap({"i", "c"}, "<C-V>", '<C-R>"')
keymap("v", "D", "\"_d")
keymap("v", "C", "\"_c")
keymap("v", "P", "\"0p")
keymap("v", "$", "g_")
keymap("n", "J", function()
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd("join " .. vim.v.count + 1)
  vim.api.nvim_win_set_cursor(0, pos)
end, {silent = true})
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")
keymap({"n", "v"}, "<C-D>", "<C-D>zz")
keymap({"n", "v"}, "<C-U>", "<C-U>zz")
keymap({"n", "v"}, "<C-O>", "<C-O>zz")
keymap({"n", "v"}, "<C-I>", "<C-I>zz")
keymap({"n", "v"}, "n", [['Nn'[v:searchforward] . 'zz']], {expr = true})
keymap({"n", "v"}, "N", [['nN'[v:searchforward] . 'zz']], {expr = true})
keymap({"n", "v"}, "#", "#zz")
keymap({"n", "v"}, "*", "*zz")
-- keymap({"n", "v"}, "#", [[<Cmd>let @/= '\<' . expand('<cword>') . '\>'<CR><Cmd>set hlsearch<CR>viwo<Esc>]],
--        {silent = true})
-- keymap({"n", "v"}, "?", "<Cmd>let @/ = input('/')<CR><Cmd>set hlsearch<CR>", {
--   silent = true,
-- })
keymap("c", "<C-J>", "<C-N>")
keymap("c", "<C-K>", "<C-P>")
keymap({"n", "v"}, "<C-S-C>", "\"+y")
keymap({"n", "v"}, "<M-Left>", "<C-O>")
keymap({"n", "v"}, "<M-Right>", "<C-I>")
keymap({"n", "v"}, "-", "^")
keymap({"n", "v"}, "<BS>", "s")
keymap({"n", "v"}, "<C-Z>", "<Nop>")

-- Space mappings
keymap({"n", "v"}, "<Space>", "<Nop>")
keymap("i", "<C-Space>", "<Nop>")
keymap({"n", "v"}, "<Space>y", "\"+y")
keymap({"n", "v"}, "<Space>Y", ":%y+<CR>")
keymap({"n", "v"}, "<Space>?", "<Cmd>set hlsearch!<CR>")
keymap({"n", "v"}, "<Space>C", "<Cmd>set ignorecase!<CR>")
keymap({"n", "v"}, "<Space>N", toggle_line_numeration)
keymap({"n", "v"}, "<Space>I", toggle_tab_width)
keymap({"n", "v"}, "<Space>W", toggle_line_wrap)
keymap("n", "<Space>/s", [[:s/\<<C-R><C-W>\>//g<Left><Left>]])
keymap("n", "<Space>e", "<Cmd>Explore<CR>", {silent = true})
keymap({"n", "v"}, "<Space>LR", "<Cmd>LspRestart<CR>")
keymap({"n", "v"}, "<Space>LI", "<Cmd>LspInfo<CR>")
keymap("n", "<space>PM", "<Plug>MarkdownPreviewToggle")
-- keymap("n", "<Space>dm <Cmd>delmarks a-zA-Z0-9<CR>

-- Splits
keymap({"n", "v"}, "<C-W>s", "<C-W>s<C-W>j")
keymap({"n", "v"}, "<C-W>v", "<C-W>v<C-W>l")
keymap({"n", "v"}, "<C-W><C-S>", "<C-W>s<C-W>j")
keymap({"n", "v"}, "<C-W><C-V>", "<C-W>v<C-W>l")
keymap({"n", "v"}, "<Tab>", "<C-6>")
keymap({"n", "v"}, "<C-W>f", "<Cmd>copen<CR>")
keymap({"n", "v"}, "<C-W><C-F>", "<Cmd>copen<CR>")

-- Fast actions
keymap({"n", "v"}, "<C-Q>", "<C-W>q")
keymap({"n", "v"}, "<C-W>;", "<C-W>p")
keymap({"n", "v"}, "<C-S>", ":<C-U>write<CR>", {silent = true})
keymap("i", "<C-S>", "<C-O>:<C-U>write<CR>", {silent = true})
keymap({"n", "v"}, "<C-,>", "<Cmd>tabprevious<CR>", {silent = true})
keymap({"n", "v"}, "<C-.>", "<Cmd>tabnext<CR>", {silent = true})

-- Tabs
keymap({"n", "v"}, "<C-W>c", "<C-W><Esc>")
keymap({"n", "v"}, "<C-W><C-c>", "<C-W><Esc>")
keymap({"n", "v"}, "<C-W>t", "<C-W>v<C-W>T", {silent = true})
keymap({"n", "v"}, "<C-W>t", [[<C-W>v<C-W>T <Bar> tabmove<CR>]], {silent = true})
keymap({"n", "v"}, "<C-W>,", "<Cmd>tabprevious<CR>", {silent = true})
keymap({"n", "v"}, "<C-W>.", "<Cmd>tabnext<CR>", {silent = true})
for i = 1, 9 do
  keymap({"n", "v"}, "<C-W>" .. i, "<Cmd>" .. i .. "tabnext<CR>", {
    silent = true,
  })
  keymap({"n", "v"}, "<Space>" .. i, "<Cmd>" .. i .. "tabnext<CR>", {
    silent = true,
  })
end
keymap({"n", "v"}, "<C-W><", "<Cmd>-tabmove<CR>", {silent = true})
keymap({"n", "v"}, "<C-W>>", "<Cmd>+tabmove<CR>", {silent = true})
keymap({"n", "v"}, "<C-W>Q", "<Cmd>tabclose<CR>", {silent = true})
keymap({"n", "v"}, "<C-W>n", ":<C-U>TabRename ")
keymap({"n", "v"}, "<C-W><C-N>", ":<C-U>TabRename ")
keymap({"n", "v"}, "<C-W><C-T>", "<C-W>v<C-W>T", {silent = true})
-- keymap({"n", "v"}, "<C-W><C-,>", "<Cmd>tabprevious<CR>", {silent = true})
-- keymap({"n", "v"}, "<C-W><C-.>", "<Cmd>tabnext<CR>", {silent = true})
keymap({"n", "v"}, "<C-W>M", "gT<Cmd>Tabmerge right<CR><C-W>l")

-- Jumplist
keymap("n", "}", [[:<C-U>execute "keepjumps normal! " . v:count1 . "}"<CR>]], {
  silent = true,
})
keymap("n", "{", [[:<C-U>execute "keepjumps normal! " . v:count1 . "{"<CR>]], {
  silent = true,
})
keymap("n", "k", [[(v:count > 1 ? "m'" . v:count . 'k' : 'gk')]], {expr = true})
keymap("n", "j", [[(v:count > 1 ? "m'" . v:count . 'j' : 'gj')]], {expr = true})
keymap("v", "k", "gk")
keymap("v", "j", "gj")

-- Custom jumps
-- keymap("n", "[i", [[m'<Cmd>call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%<' . line('.') . 'l\S', 'be')<CR>]], {silent = true})
-- keymap("n", "]i", [[m'<Cmd>call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%>' . line('.') . 'l\S', 'e')<CR>]], {silent = true})

-- Snippets
keymap("s", "<BS>", "_<C-W>")
keymap("s", "<C-C>", "<Esc>")

-- Tmux integration
local tmux = require("tmux")
keymap({"n", "v"}, "<C-H>", tmux.move_left)
keymap({"n", "v"}, "<C-J>", tmux.move_bottom)
keymap({"n", "v"}, "<C-K>", tmux.move_top)
keymap({"n", "v"}, "<C-L>", tmux.move_right)
keymap({"n", "v"}, "<C-S-H>", tmux.resize_left)
keymap({"n", "v"}, "<C-S-J>", tmux.resize_bottom)
keymap({"n", "v"}, "<C-S-K>", tmux.resize_top)
keymap({"n", "v"}, "<C-S-L>", tmux.resize_right)

-- Bugfix
keymap({"n", "v"}, "<M-Tab>", "<C-I>zz") -- tmux
