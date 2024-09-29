local keymap = vim.keymap.set
local lib = require("lib.main")

local function toggle_line_numeration()
  vim.opt.number = not vim.o.number
  vim.opt.relativenumber = vim.o.number
end
local function toggle_relative_numeration()
  if vim.o.number then
    vim.opt.relativenumber = not vim.o.relativenumber
  end
end
local function toggle_tab_width()
  vim.opt.shiftwidth = vim.o.shiftwidth == 4 and 2 or 4
  vim.opt.tabstop = vim.o.shiftwidth
  vim.opt.softtabstop = vim.o.shiftwidth
end
local function toggle_line_wrap()
  vim.opt.wrap = not vim.o.wrap
end
local function rename_tab()
  local tabname = vim.fn.input("New tab name: ")
  if tabname then
    vim.cmd("TabRename " .. tabname)
  end
end
local function toggle_fixed_signcolumn()
  if vim.o.signcolumn:find("auto") then
    vim.opt.signcolumn = "yes"
  else
    vim.opt.signcolumn = "auto:1-2"
  end
end
local function prev_insert_pos()
  pcall(function()
    local next_row = unpack(vim.api.nvim_win_get_cursor(0))
    repeat
      local prev_row = next_row
      lib.norm("g;")
      next_row = unpack(vim.api.nvim_win_get_cursor(0))
    until prev_row ~= next_row
  end)
end
local function longjump(key)
  pcall(function()
    local prime_buf = vim.api.nvim_get_current_buf()
    local next_row = -1
    repeat
      local prev_row = next_row
      lib.norm(key)
      next_row = unpack(vim.api.nvim_win_get_cursor(0))
    until prime_buf ~= vim.api.nvim_get_current_buf() or prev_row == next_row
    -- lib.center_win()
  end)
end
local function longjump_back()
  longjump("<C-O>")
end
local function longjump_forward()
  longjump("<C-I>")
end
local function yank_all_sys_clip()
  lib.norm("mm")
  vim.cmd("%y y")
  vim.fn.setreg("+", vim.fn.getreg("y"):sub(1, -2))
end

-- Default behaviour
keymap({ "n", "x" }, "<C-C>", "<Esc>")
keymap("i", "<C-C>", "<Esc>")
keymap("i", "<C-Del>", "<C-O>de")
keymap("i", "<C-V>", function()
  local joined_clipboard = vim.fn.getreg('"'):gsub("[\n\r]", " "):gsub("%s+", " ")
  vim.api.nvim_put({ joined_clipboard }, "", false, true)
end)
keymap("c", "<C-V>", '<C-R>"')
keymap({ "n", "x" }, "<BS>", "s")
keymap("x", "$", "g_")
keymap("n", "J", function()
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd("join " .. vim.v.count + 1)
  vim.api.nvim_win_set_cursor(0, pos)
end)
keymap("c", "<C-J>", "<C-N>")
keymap("c", "<C-K>", "<C-P>")
keymap({ "n", "x" }, "<C-S-C>", [[mm"+y]])
keymap({ "n", "x" }, "<M-Left>", "<C-O>")
keymap({ "n", "x" }, "<M-Right>", "<C-I>")
keymap({ "n", "x" }, "<C-Z>", "<Nop>")
keymap({ "n", "x" }, "y", "mmy")
-- keymap({ "n", "x" }, "p", "p`]")
-- keymap({ "n", "x" }, "P", "P`]")

-- Visual actions
keymap("x", "P", [["0p]])

-- Navigation
keymap({ "n", "x" }, "ZL", "zL")
keymap({ "n", "x" }, "ZH", "zH")

-- Search
keymap({ "n", "x" }, "n", "'Nn'[v:searchforward]", { expr = true })
keymap({ "n", "x" }, "N", "'nN'[v:searchforward]", { expr = true })
keymap({ "n", "x" }, "g/", [[/\<\><Left><Left>]])
keymap({ "n", "x" }, "g?", [[?\<\><Left><Left>]])
-- keymap({ "n", "x" }, "<Space>/", function()
--   vim.fn.setreg("/", vim.fn.input("/"))
-- end)
-- keymap({ "n" }, "<Space>/", function()
--   vim.fn.setreg("/", "/\<\><")
-- end)
keymap({ "n" }, "<CR>", function()
  vim.fn.setreg("/", [[\<]] .. vim.fn.expand("<cword>") .. [[\>]])
end)
keymap({ "n" }, "g<CR>", function()
  vim.fn.setreg("/", vim.fn.expand("<cword>"))
end)
keymap({ "x" }, "<CR>", function()
  vim.fn.setreg("/", lib.get_visual())
  lib.norm("<Esc>")
end)

-- Space mappings
keymap({ "n", "x" }, "<Space>", "<Nop>")
keymap({ "n", "x" }, "<S-Space>", "<Space>", { remap = true })
keymap("i", "<C-Space>", "<Nop>")
keymap({ "n", "x" }, "<Space>y", [[mm"+y]])
keymap("n", "<Space>yy", [[mm0vg_"+y]])
keymap({ "n", "x" }, "<Space>Y", yank_all_sys_clip)
-- keymap({ "n", "x" }, "<Space>p", [["+p]])
-- keymap({ "n", "x" }, "<Space>P", [["+P]])
keymap({ "n", "x" }, "<Space>?", "<Cmd>set hlsearch!<CR>")
keymap({ "n", "x" }, "<Space>I", "<Cmd>set ignorecase!<CR>")
keymap({ "n", "x" }, "<Space>LN", toggle_line_numeration)
keymap({ "n", "x" }, "<Space>RN", toggle_relative_numeration)
keymap({ "n", "x" }, "<Space>TW", toggle_tab_width)
keymap({ "n", "x" }, "<Space>LW", toggle_line_wrap)
keymap("n", "<Space>D", [[:%s/\s\+$//e<CR>/<Up><Up><CR><C-O>]])
keymap({ "n", "x" }, "<Space>C", toggle_fixed_signcolumn)
keymap("n", "<Space>s", [[:s/\<<C-R><C-W>\>//g<Left><Left>]])
keymap("n", "<Space>S", [[:%s/\<<C-R><C-W>\>//g<Left><Left>]])
keymap("x", "<Space>s", function()
  local replacement = vim.fn.input("New: ")
  if replacement ~= "" then
    vim.cmd("s/" .. lib.get_visual() .. "/" .. replacement .. "/g")
  end
  lib.norm([[<Esc>]])
end)
keymap("x", "<Space>S", function()
  vim.cmd([[%s/]] .. lib.get_visual() .. "/" .. vim.fn.input("New: ") .. "/g")
  lib.norm([[<Esc><C-O>]])
end)
vim.keymap.set("n", "<Space>e", vim.cmd.NvimTreeFindFile)
keymap({ "n", "x" }, "<Space>LR", vim.cmd.LspRestart)
keymap({ "n", "x" }, "<Space>LI", vim.cmd.LspInfo)
keymap({ "n", "x" }, "<Space>BD", function()
  vim.cmd("%bd")
  lib.norm("<C-O>")
end)

-- Splits
keymap({ "n", "x" }, "<C-W>s", "<C-W>s<C-W>j")
keymap({ "n", "x" }, "<C-W>v", "<C-W>v<C-W>l")
keymap({ "n", "x" }, "<C-W><C-S>", "<C-W>s<C-W>j")
keymap({ "n", "x" }, "<C-W><C-V>", "<C-W>v<C-W>l")
keymap({ "n", "x" }, "<C-W>;", "<C-W>p")
keymap({ "n", "x" }, "<C-H>", "<C-W>h")
keymap({ "n", "x" }, "<C-J>", "<C-W>j")
keymap({ "n", "x" }, "<C-K>", "<C-W>k")
keymap({ "n", "x" }, "<C-L>", "<C-W>l")
-- keymap({ "n", "x" }, "<C-S-H>", "3<C-W><")
-- keymap({ "n", "x" }, "<C-S-J>", "<C-W>-")
-- keymap({ "n", "x" }, "<C-S-K>", "<C-W>+")
-- keymap({ "n", "x" }, "<C-S-L>", "3<C-W>>")

-- Tabs
keymap({ "n", "x" }, "<C-W>c", "<C-W><Esc>")
keymap({ "n", "x" }, "<C-W><C-c>", "<C-W><Esc>")
keymap({ "n", "x" }, "<C-W>t", "<C-W>v<C-W>T")
keymap({ "n", "x" }, "<C-W><C-T>", "<C-W>v<C-W>T")
keymap({ "n", "x" }, "<C-W>,", vim.cmd.tabprevious)
keymap({ "n", "x" }, "<C-W>.", vim.cmd.tabnext)
keymap({ "n", "x" }, "<C-W><C-,>", vim.cmd.tabprevious)
keymap({ "n", "x" }, "<C-W><C-.>", vim.cmd.tabnext)
for i = 1, 9 do
  keymap({ "n", "x" }, "<C-W>" .. i, "<Cmd>" .. i .. "tabnext<CR>")
  keymap({ "n", "x" }, "<Space>" .. i, "<Cmd>" .. i .. "tabnext<CR>")
end
keymap({ "n", "x" }, "<C-W><", "<Cmd>-tabmove<CR>")
keymap({ "n", "x" }, "<C-W>>", "<Cmd>+tabmove<CR>")
keymap({ "n", "x" }, "<C-W>Q", vim.cmd.tabclose)
keymap({ "n", "x" }, "<C-W>n", rename_tab)
keymap({ "n", "x" }, "<C-W><C-N>", rename_tab)
keymap({ "n", "x" }, "<C-W>M", "gT<Cmd>Tabmerge right<CR><C-W>l")
keymap({ "n", "x" }, "<Space><Tab>", "g<Tab>")
keymap({ "n", "x" }, "<C-W>p", "g<Tab>")

-- Jumps
keymap({ "n", "x" }, "{", function()
  vim.fn.execute("keepjumps normal! " .. vim.v.count .. "{")
end)
keymap({ "n", "x" }, "}", function()
  vim.fn.execute("keepjumps normal! " .. vim.v.count .. "}")
end)
keymap({ "n", "x" }, "j", [[(v:count > 1 ? "m'" . v:count . 'j' : 'gj')]], {
  expr = true,
})
keymap({ "n", "x" }, "k", [[(v:count > 1 ? "m'" . v:count . 'k' : 'gk')]], {
  expr = true,
})
keymap("n", "g;", prev_insert_pos)
keymap("n", "g<C-O>", longjump_back)
keymap("n", "g<C-I>", longjump_forward)
keymap("n", "<C-M-Left>", longjump_back)
keymap("n", "<C-M-Right>", longjump_forward)

-- Quickfix list
keymap({ "n", "x" }, "gq", vim.cmd.copen)
keymap({ "n", "x" }, "[q", lib.cprev)
keymap({ "n", "x" }, "]q", lib.cnext)

-- Marks
local buffer_marks = "abcdefghijklmnopqrstuvwxyz"
for i = 1, #buffer_marks do
  local mark = buffer_marks:sub(i, i)
  keymap({ "n", "x" }, "m" .. mark, "m" .. mark:upper())
  keymap({ "n", "x" }, "'" .. mark, "'" .. mark:upper())
  -- keymap("n", "dm" .. mark, function() vim.cmd.delmarks(mark:upper()) end)
  -- keymap("n", "dm" .. mark:upper(), function() vim.cmd.delmarks(mark:upper()) end)
end
keymap("n", "dM", function()
  vim.cmd.delmarks("a-zA-Z")
end)

-- Fast actions
keymap({ "n", "x" }, "<C-Q>", function()
  pcall(lib.norm, "<C-W>q")
end)
keymap({ "n", "x" }, "<C-S>", ":<C-U>write<CR>", { silent = true })
keymap("i", "<C-S>", "<C-O>:<C-U>write<CR>", { silent = true })
keymap("i", "<C-Z>", "<C-O>u")
keymap("i", "<C-S-Z>", "<C-O><C-R>")
keymap({ "n", "x" }, "<Tab>", "<C-^>")

-- Mouse
keymap({ "n", "x" }, "<S-ScrollWheelUp>", "<ScrollWheelLeft>")
keymap({ "n", "x" }, "<S-ScrollWheelDown>", "<ScrollWheelRight>")

-- Snippets
keymap("s", "<BS>", "_<C-W>")
keymap("s", "<C-C>", "<Esc>")

-- Bugfix
keymap({ "n", "x" }, "<M-Tab>", "<C-I>")
function longjump_forward()
  longjump("<M-Tab>")
end
keymap("n", "g<M-Tab>", longjump_forward)
keymap("n", "<C-M-Right>", longjump_forward)
