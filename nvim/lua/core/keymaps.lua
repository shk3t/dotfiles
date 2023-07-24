local keymap = vim.keymap.set

local function toggle_line_numeration()
  vim.opt.number = not vim.o.number
  vim.opt.relativenumber = vim.o.number
end
local function toggle_relative_numeration() if vim.o.number then vim.opt.relativenumber = not vim.o.relativenumber end end
local function toggle_tab_width()
  vim.opt.shiftwidth = vim.o.shiftwidth == 4 and 2 or 4
  vim.opt.tabstop = vim.o.shiftwidth
  vim.opt.softtabstop = vim.o.shiftwidth
end
local function toggle_line_wrap() vim.opt.wrap = not vim.o.wrap end
local function rename_tab()
  local tabname = vim.fn.input("New tab name: ")
  if tabname then vim.cmd("TabRename " .. tabname) end
end
local function toggle_fixed_signcolumn()
  if string.find(vim.o.signcolumn, "auto") then
    vim.opt.signcolumn = "yes"
  else
    vim.opt.signcolumn = "auto:1-2"
  end
end

-- Commands
vim.cmd([[command! Cdc cd %:p:h]])

-- Default behaviour
keymap({"n", "v"}, "<C-C>", "<Esc>")
keymap("i", "<C-C>", "<Esc>")
keymap("i", "<C-Del>", "<C-O>de")
keymap({"i", "c"}, "<C-V>", "<C-R>\"")
keymap({"n", "v"}, "<BS>", "s")
keymap("v", "$", "g_")
keymap("n", "J", function()
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd("join " .. vim.v.count + 1)
  vim.api.nvim_win_set_cursor(0, pos)
end)
keymap("c", "<C-J>", "<C-N>")
keymap("c", "<C-K>", "<C-P>")
keymap({"n", "v"}, "<C-S-C>", [["+y]])
keymap({"n", "v"}, "<M-Left>", "<C-O>")
keymap({"n", "v"}, "<M-Right>", "<C-I>")
-- keymap({"n", "v"}, "-", "^")
keymap({"n", "v"}, "<C-Z>", "<Nop>")

-- Visual actions
keymap("v", "D", [["_d]])
keymap("v", "C", [["_c]])
keymap("v", "P", [["0p]])
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

-- Focus
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

-- Space mappings
keymap({"n", "v"}, "<Space>", "<Nop>")
keymap("i", "<C-Space>", "<Nop>")
keymap({"n", "v"}, "<Space>y", [["+y]])
keymap({"n", "v"}, "<Space>Y", ":%y+<CR>")
keymap({"n", "v"}, "<Space>?", "<Cmd>set hlsearch!<CR>")
keymap({"n", "v"}, "<Space>I", "<Cmd>set ignorecase!<CR>")
keymap({"n", "v"}, "<Space>N", toggle_line_numeration)
keymap({"n", "v"}, "<Space>R", toggle_relative_numeration)
keymap({"n", "v"}, "<Space>T", toggle_tab_width)
keymap({"n", "v"}, "<Space>W", toggle_line_wrap)
keymap("n", "<Space>D", [[:%s/\s\+$//e<CR>/<Up><Up><CR><C-O>]])
keymap({"n", "v"}, "<Space>C", toggle_fixed_signcolumn)
keymap("n", "<Space>/s", [[:s/\<<C-R><C-W>\>//g<Left><Left>]])
keymap("n", "<Space>e", vim.cmd.Ex)
keymap({"n", "v"}, "<Space>LR", vim.cmd.LspRestart)
keymap({"n", "v"}, "<Space>LI", vim.cmd.LspInfo)
keymap({"n", "v"}, "<Space>PM", vim.cmd.MarkdownPreviewToggle)

-- Splits
keymap({"n", "v"}, "<C-W>s", "<C-W>s<C-W>j")
keymap({"n", "v"}, "<C-W>v", "<C-W>v<C-W>l")
keymap({"n", "v"}, "<C-W><C-S>", "<C-W>s<C-W>j")
keymap({"n", "v"}, "<C-W><C-V>", "<C-W>v<C-W>l")

-- Tabs
keymap({"n", "v"}, "<C-W>c", "<C-W><Esc>")
keymap({"n", "v"}, "<C-W><C-c>", "<C-W><Esc>")
keymap({"n", "v"}, "<C-W>t", "<C-W>v<C-W>T")
keymap({"n", "v"}, "<C-W><C-T>", "<C-W>v<C-W>T")
keymap({"n", "v"}, "<C-W>,", vim.cmd.tabprevious)
keymap({"n", "v"}, "<C-W>.", vim.cmd.tabnext)
for i = 1, 9 do
  keymap({"n", "v"}, "<C-W>" .. i, "<Cmd>" .. i .. "tabnext<CR>")
  keymap({"n", "v"}, "<Space>" .. i, "<Cmd>" .. i .. "tabnext<CR>")
end
keymap({"n", "v"}, "<C-W><", "<Cmd>-tabmove<CR>")
keymap({"n", "v"}, "<C-W>>", "<Cmd>+tabmove<CR>")
keymap({"n", "v"}, "<C-W>Q", vim.cmd.tabclose)
keymap({"n", "v"}, "<C-W>n", rename_tab)
keymap({"n", "v"}, "<C-W><C-N>", rename_tab)
keymap({"n", "v"}, "<C-W>M", "gT<Cmd>Tabmerge right<CR><C-W>l")
keymap({"n", "v"}, "<S-Tab>", "g<Tab>")
keymap({"n", "v"}, "<Space><Tab>", "g<Tab>")

-- Jumplist
keymap("n", "{", function() vim.fn.execute("keepjumps normal! " .. vim.v.count .. "{") end)
keymap("n", "}", function() vim.fn.execute("keepjumps normal! " .. vim.v.count .. "}") end)
keymap("n", "j", [[(v:count > 1 ? "m'" . v:count . 'j' : 'gj')]], {expr = true})
keymap("n", "k", [[(v:count > 1 ? "m'" . v:count . 'k' : 'gk')]], {expr = true})
keymap("v", "j", "gj")
keymap("v", "k", "gk")

-- Quickfix list
keymap({"n", "v"}, "<Space>qf", vim.cmd.copen)
keymap({"n", "v"}, "[q", function() if not pcall(vim.cmd.cprevious) then vim.cmd.clast() end end)
keymap({"n", "v"}, "]q", function() if not pcall(vim.cmd.cnext) then vim.cmd.cfirst() end end)

-- Marks
local buffer_marks = "abcdefghijklmnopqrstuvwxyz"
for i = 1, #buffer_marks do
  local mark = buffer_marks:sub(i, i)
  keymap({"n", "v"}, "m" .. mark, "m" .. mark:upper())
  keymap({"n", "v"}, "'" .. mark, "'" .. mark:upper())
  keymap("n", "dm" .. mark, function() vim.cmd.delmarks(mark:upper()) end)
  keymap("n", "dm" .. mark:upper(), function() vim.cmd.delmarks(mark:upper()) end)
end keymap("n", "DM", function() vim.cmd.delmarks("a-zA-Z") end)

-- Fast actions
keymap({"n", "v"}, "<C-Q>", "<C-W>q")
keymap({"n", "v"}, "<C-W>;", "<C-W>p")
keymap({"n", "v"}, "<C-S>", ":<C-U>write<CR>", {silent = true})
keymap("i", "<C-S>", "<C-O>:<C-U>write<CR>", {silent = true})
keymap({"n", "v"}, "<C-,>", vim.cmd.tabprevious)
keymap({"n", "v"}, "<C-.>", vim.cmd.tabnext)
keymap({"n", "v"}, "<Tab>", "<C-6>")

-- Custom jumps
-- keymap("n", "[i", [[m'<Cmd>call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%<' . line('.') . 'l\S', 'be')<CR>]], {silent = true})
-- keymap("n", "]i", [[m'<Cmd>call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%>' . line('.') . 'l\S', 'e')<CR>]], {silent = true})

-- Snippets
keymap("s", "<BS>", "_<C-W>")
keymap("s", "<C-C>", "<Esc>")

-- Bugfix
keymap({"n", "v"}, "<M-Tab>", "<C-I>zz") -- tmux
