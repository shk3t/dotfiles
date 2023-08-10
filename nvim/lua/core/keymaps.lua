local keymap = vim.keymap.set
local t = require("utils.main").replace_termcodes
local vc_cmd = require("utils.main").vc_cmd
local cprev = require("utils.main").cprev
local cnext = require("utils.main").cnext

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
local function current_file_in_explorer()
  local filename = vim.fn.expand("%:t")
  vim.cmd.Ex()
  local searchreg = vim.fn.getreg("/")
  vim.cmd(t("normal! /" .. filename .. "<CR>"))
  vim.fn.setreg("/", searchreg)
end
local function prev_insert_pos()
  pcall(function()
    local next_row = unpack(vim.api.nvim_win_get_cursor(0))
    repeat
      local prev_row = next_row
      vim.cmd(t("normal! g;"))
      next_row = unpack(vim.api.nvim_win_get_cursor(0))
    until prev_row ~= next_row
  end)
end
local function longjump(key)
  local prime_buf = vim.api.nvim_get_current_buf()
  local next_row = -1
  repeat
    local prev_row = next_row
    vim.cmd("normal! " .. key)
    next_row = unpack(vim.api.nvim_win_get_cursor(0))
  until prime_buf ~= vim.api.nvim_get_current_buf() or prev_row == next_row
  -- vim.cmd("normal! zz")
end
local function longjump_back() longjump(t("<C-O>")) end
local function longjump_forward() longjump(t("<C-I>")) end

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
-- keymap({"n", "v"}, "<C-D>", "<C-D>zz")
-- keymap({"n", "v"}, "<C-U>", "<C-U>zz")
-- keymap({"n", "v"}, "<C-O>", "<C-O>zz")
-- keymap({"n", "v"}, "<C-I>", "<C-I>zz")
-- keymap({"n", "v"}, "n", [['Nn'[v:searchforward] . 'zz']], {expr = true})
-- keymap({"n", "v"}, "N", [['nN'[v:searchforward] . 'zz']], {expr = true})
keymap({"n", "v"}, "n", "'Nn'[v:searchforward]", {expr = true})
keymap({"n", "v"}, "N", "'nN'[v:searchforward]", {expr = true})
-- keymap({"n", "v"}, "#", "#zz")
-- keymap({"n", "v"}, "*", "*zz")
keymap({"n", "v"}, "<Space>/", function() vim.fn.setreg("/", vim.fn.input("/")) end)

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
keymap({"n", "v"}, "<Space>S", toggle_fixed_signcolumn)
keymap("n", "<Space>:s", [[:s/\<<C-R><C-W>\>//g<Left><Left>]])
keymap("n", "<Space>:S", [[:%s/\<<C-R><C-W>\>//g<Left><Left>]])
-- keymap("n", "<Space>e", current_file_in_explorer)
vim.keymap.set("n", "<Space>e", vim.cmd.NvimTreeFindFile)
keymap({"n", "v"}, "<Space>LR", vim.cmd.LspRestart)
keymap({"n", "v"}, "<Space>LI", vim.cmd.LspInfo)
keymap({"n", "v"}, "<Space>PM", vim.cmd.MarkdownPreviewToggle)

-- Splits
keymap({"n", "v"}, "<C-W>s", "<C-W>s<C-W>j")
keymap({"n", "v"}, "<C-W>v", "<C-W>v<C-W>l")
keymap({"n", "v"}, "<C-W><C-S>", "<C-W>s<C-W>j")
keymap({"n", "v"}, "<C-W><C-V>", "<C-W>v<C-W>l")
keymap({"n", "v"}, "<C-W>;", "<C-W>p")

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
-- keymap({"n", "v"}, "<S-Tab>", "g<Tab>")
keymap({"n", "v"}, "<Space><Tab>", "g<Tab>")
keymap({"n", "v"}, "<C-W>p", "g<Tab>")

-- Jumps
keymap({"n", "v"}, "{", function() vim.fn.execute("keepjumps normal! " .. vim.v.count .. "{") end)
keymap({"n", "v"}, "}", function() vim.fn.execute("keepjumps normal! " .. vim.v.count .. "}") end)
keymap({"n", "v"}, "j", [[(v:count > 1 ? "m'" . v:count . 'j' : 'gj')]], {
  expr = true,
})
keymap({"n", "v"}, "k", [[(v:count > 1 ? "m'" . v:count . 'k' : 'gk')]], {
  expr = true,
})
keymap("n", "g;", prev_insert_pos)
keymap("n", "g<C-O>", longjump_back)
keymap("n", "g<C-I>", longjump_forward)

-- Quickfix list
keymap({"n", "v"}, "<Space>qf", vim.cmd.copen)
keymap({"n", "v"}, "[q", cprev)
keymap({"n", "v"}, "]q", cnext)

-- Marks
local buffer_marks = "abcdefghijklmnopqrstuvwxyz"
for i = 1, #buffer_marks do
  local mark = buffer_marks:sub(i, i)
  keymap({"n", "v"}, "m" .. mark, "m" .. mark:upper())
  keymap({"n", "v"}, "'" .. mark, "'" .. mark:upper())
  -- keymap({"n", "v"}, "'" .. mark, "'" .. mark:upper() .. "zz")
  keymap("n", "dm" .. mark, function() vim.cmd.delmarks(mark:upper()) end)
  keymap("n", "dm" .. mark:upper(), function() vim.cmd.delmarks(mark:upper()) end)
end
keymap("n", "dM", function() vim.cmd.delmarks("a-zA-Z") end)

-- Fast actions
keymap({"n", "v"}, "<C-Q>", "<C-W>q")
keymap({"n", "v"}, "<C-S>", ":<C-U>write<CR>", {silent = true})
keymap("i", "<C-S>", "<C-O>:<C-U>write<CR>", {silent = true})
keymap({"n", "v"}, "<C-,>", vim.cmd.tabprevious)
keymap({"n", "v"}, "<C-.>", vim.cmd.tabnext)
keymap({"n", "v"}, "<Tab>", "<C-^>")
-- keymap({"n", "v"}, "<Tab>", function()
--   if not pcall(function()
--     local bufnrs = require("utils.main").get_recent_buffers()
--     local prev_buffer, prev_prev_buffer = bufnrs[2], bufnrs[3]
--     if vim.api.nvim_buf_get_option(prev_buffer, "filetype") == "netrw" then
--       vim.api.nvim_set_current_buf(prev_prev_buffer)
--     else
--       vim.api.nvim_set_current_buf(prev_buffer)
--     end
--   end) then vim.cmd(t("normal! <C-^>")) end
-- end)

-- Custom jumps
-- keymap("n", "[i", [[m'<Cmd>call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%<' . line('.') . 'l\S', 'be')<CR>]], {silent = true})
-- keymap("n", "]i", [[m'<Cmd>call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%>' . line('.') . 'l\S', 'e')<CR>]], {silent = true})

-- Snippets
keymap("s", "<BS>", "_<C-W>")
keymap("s", "<C-C>", "<Esc>")

-- Bugfix
keymap({"n", "v"}, "<M-Tab>", "<C-I>")
function longjump_forward() longjump(t("<M-Tab>")) end
keymap("n", "g<M-Tab>", longjump_forward)
