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
keymap({ "n", "v" }, "<C-C>", "<Esc>")
keymap("i", "<C-C>", "<Esc>")
keymap("i", "<C-Del>", "<C-O>de")
keymap("i", "<C-V>", function()
  local joined_clipboard = vim.fn.getreg('"'):gsub("[\n\r]", " "):gsub("%s+", " ")
  vim.api.nvim_put({ joined_clipboard }, "", false, true)
end)
keymap("c", "<C-V>", '<C-R>"')
keymap({ "n", "v" }, "<BS>", "s")
keymap("v", "$", "g_")
keymap("n", "J", function()
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd("join " .. vim.v.count + 1)
  vim.api.nvim_win_set_cursor(0, pos)
end)
keymap("c", "<C-J>", "<C-N>")
keymap("c", "<C-K>", "<C-P>")
keymap({ "n", "v" }, "<C-S-C>", [[mm"+y]])
keymap({ "n", "v" }, "<M-Left>", "<C-O>")
keymap({ "n", "v" }, "<M-Right>", "<C-I>")
keymap({ "n", "v" }, "<C-Z>", "<Nop>")
keymap({ "n", "v" }, "y", "mmy")
-- keymap({ "n", "v" }, "p", "p`]")
-- keymap({ "n", "v" }, "P", "P`]")

-- Visual actions
keymap("v", "P", [["0p]])

-- Navigation
keymap({ "n", "v" }, "ZL", "zL")
keymap({ "n", "v" }, "ZH", "zH")

-- Search
keymap({ "n", "v" }, "n", "'Nn'[v:searchforward]", { expr = true })
keymap({ "n", "v" }, "N", "'nN'[v:searchforward]", { expr = true })
keymap({ "n", "v" }, "g/", [[/\<\><Left><Left>]])
keymap({ "n", "v" }, "g?", [[?\<\><Left><Left>]])
-- keymap({ "n", "v" }, "<Space>/", function()
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
keymap({ "v" }, "<CR>", function()
  vim.fn.setreg("/", lib.get_visual())
  lib.norm("<Esc>")
end)

-- Space mappings
keymap({ "n", "v" }, "<Space>", "<Nop>")
keymap({ "n", "v" }, "<S-Space>", "<Space>", { remap = true })
keymap("i", "<C-Space>", "<Nop>")
keymap({ "n", "v" }, "<Space>y", [[mm"+y]])
keymap("n", "<Space>yy", [[mm0vg_"+y]])
keymap({ "n", "v" }, "<Space>Y", yank_all_sys_clip)
-- keymap({ "n", "v" }, "<Space>p", [["+p]])
-- keymap({ "n", "v" }, "<Space>P", [["+P]])
keymap({ "n", "v" }, "<Space>?", "<Cmd>set hlsearch!<CR>")
keymap({ "n", "v" }, "<Space>I", "<Cmd>set ignorecase!<CR>")
keymap({ "n", "v" }, "<Space>LN", toggle_line_numeration)
keymap({ "n", "v" }, "<Space>RN", toggle_relative_numeration)
keymap({ "n", "v" }, "<Space>TW", toggle_tab_width)
keymap({ "n", "v" }, "<Space>LW", toggle_line_wrap)
keymap("n", "<Space>D", [[:%s/\s\+$//e<CR>/<Up><Up><CR><C-O>]])
keymap({ "n", "v" }, "<Space>C", toggle_fixed_signcolumn)
keymap("n", "\\s", [[:s/\<<C-R><C-W>\>//g<Left><Left>]])
keymap("n", "\\S", [[:%s/\<<C-R><C-W>\>//g<Left><Left>]])
keymap("v", "\\s", function()
  local replacement = vim.fn.input("New: ")
  if replacement ~= "" then
    vim.cmd("s/" .. lib.get_visual() .. "/" .. replacement .. "/g")
  end
  lib.norm([[<Esc>]])
end)
keymap("v", "\\S", function()
  vim.cmd([[%s/]] .. lib.get_visual() .. "/" .. vim.fn.input("New: ") .. "/g")
  lib.norm([[<Esc><C-O>]])
end)
vim.keymap.set("n", "<Space>e", vim.cmd.NvimTreeFindFile)
keymap({ "n", "v" }, "<Space>LR", vim.cmd.LspRestart)
keymap({ "n", "v" }, "<Space>LI", vim.cmd.LspInfo)
keymap({ "n", "v" }, "<Space>BD", function()
  vim.cmd("%bd")
  lib.norm("<C-O>")
end)

-- Splits
keymap({ "n", "v" }, "<C-W>s", "<C-W>s<C-W>j")
keymap({ "n", "v" }, "<C-W>v", "<C-W>v<C-W>l")
keymap({ "n", "v" }, "<C-W><C-S>", "<C-W>s<C-W>j")
keymap({ "n", "v" }, "<C-W><C-V>", "<C-W>v<C-W>l")
keymap({ "n", "v" }, "<C-W>;", "<C-W>p")
keymap({ "n", "v" }, "<C-H>", "<C-W>h")
keymap({ "n", "v" }, "<C-J>", "<C-W>j")
keymap({ "n", "v" }, "<C-K>", "<C-W>k")
keymap({ "n", "v" }, "<C-L>", "<C-W>l")
-- keymap({ "n", "v" }, "<C-S-H>", "3<C-W><")
-- keymap({ "n", "v" }, "<C-S-J>", "<C-W>-")
-- keymap({ "n", "v" }, "<C-S-K>", "<C-W>+")
-- keymap({ "n", "v" }, "<C-S-L>", "3<C-W>>")

-- Tabs
keymap({ "n", "v" }, "<C-W>c", "<C-W><Esc>")
keymap({ "n", "v" }, "<C-W><C-c>", "<C-W><Esc>")
keymap({ "n", "v" }, "<C-W>t", "<C-W>v<C-W>T")
keymap({ "n", "v" }, "<C-W><C-T>", "<C-W>v<C-W>T")
keymap({ "n", "v" }, "<C-W>,", vim.cmd.tabprevious)
keymap({ "n", "v" }, "<C-W>.", vim.cmd.tabnext)
keymap({ "n", "v" }, "<C-W><C-,>", vim.cmd.tabprevious)
keymap({ "n", "v" }, "<C-W><C-.>", vim.cmd.tabnext)
for i = 1, 9 do
  keymap({ "n", "v" }, "<C-W>" .. i, "<Cmd>" .. i .. "tabnext<CR>")
  keymap({ "n", "v" }, "<Space>" .. i, "<Cmd>" .. i .. "tabnext<CR>")
end
keymap({ "n", "v" }, "<C-W><", "<Cmd>-tabmove<CR>")
keymap({ "n", "v" }, "<C-W>>", "<Cmd>+tabmove<CR>")
keymap({ "n", "v" }, "<C-W>Q", vim.cmd.tabclose)
keymap({ "n", "v" }, "<C-W>n", rename_tab)
keymap({ "n", "v" }, "<C-W><C-N>", rename_tab)
keymap({ "n", "v" }, "<C-W>M", "gT<Cmd>Tabmerge right<CR><C-W>l")
keymap({ "n", "v" }, "<Space><Tab>", "g<Tab>")
keymap({ "n", "v" }, "<C-W>p", "g<Tab>")

-- Jumps
keymap({ "n", "v" }, "{", function()
  vim.fn.execute("keepjumps normal! " .. vim.v.count .. "{")
end)
keymap({ "n", "v" }, "}", function()
  vim.fn.execute("keepjumps normal! " .. vim.v.count .. "}")
end)
keymap({ "n", "v" }, "j", [[(v:count > 1 ? "m'" . v:count . 'j' : 'gj')]], {
  expr = true,
})
keymap({ "n", "v" }, "k", [[(v:count > 1 ? "m'" . v:count . 'k' : 'gk')]], {
  expr = true,
})
keymap("n", "g;", prev_insert_pos)
keymap("n", "g<C-O>", longjump_back)
keymap("n", "g<C-I>", longjump_forward)
keymap("n", "<C-M-Left>", longjump_back)
keymap("n", "<C-M-Right>", longjump_forward)

-- Quickfix list
keymap({ "n", "v" }, "gq", vim.cmd.copen)
keymap({ "n", "v" }, "[q", lib.cprev)
keymap({ "n", "v" }, "]q", lib.cnext)

-- Marks
local buffer_marks = "abcdefghijklmnopqrstuvwxyz"
for i = 1, #buffer_marks do
  local mark = buffer_marks:sub(i, i)
  keymap({ "n", "v" }, "m" .. mark, "m" .. mark:upper())
  keymap({ "n", "v" }, "'" .. mark, "'" .. mark:upper())
  -- keymap("n", "dm" .. mark, function() vim.cmd.delmarks(mark:upper()) end)
  -- keymap("n", "dm" .. mark:upper(), function() vim.cmd.delmarks(mark:upper()) end)
end
keymap("n", "dM", function()
  vim.cmd.delmarks("a-zA-Z")
end)

-- Fast actions
keymap({ "n", "v" }, "<C-Q>", function()
  pcall(lib.norm, "<C-W>q")
end)
keymap({ "n", "v" }, "<C-S>", ":<C-U>write<CR>", { silent = true })
keymap("i", "<C-S>", "<C-O>:<C-U>write<CR>", { silent = true })
keymap("i", "<C-Z>", "<C-O>u")
keymap("i", "<C-S-Z>", "<C-O><C-R>")
keymap({ "n", "v" }, "<Tab>", "<C-^>")

-- Mouse
keymap({ "n", "v" }, "<S-ScrollWheelUp>", "<ScrollWheelLeft>")
keymap({ "n", "v" }, "<S-ScrollWheelDown>", "<ScrollWheelRight>")

-- Snippets
keymap("s", "<BS>", "_<C-W>")
keymap("s", "<C-C>", "<Esc>")

-- Bugfix
keymap({ "n", "v" }, "<M-Tab>", "<C-I>")
function longjump_forward()
  longjump("<M-Tab>")
end
keymap("n", "g<M-Tab>", longjump_forward)
keymap("n", "<C-M-Right>", longjump_forward)
