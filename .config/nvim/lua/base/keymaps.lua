local keymap = vim.keymap.set
local klib = require("lib.keymaps")
local ulib = require("lib.utils")

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

-- Distinguish keypresses
keymap("n", "<C-I>", "<C-I>")
keymap("n", "<C-M>", "<C-M>")

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
  vim.fn.setreg("/", ulib.get_visual())
  ulib.norm("<Esc>")
end)

-- Space mappings
keymap({ "n", "v" }, "<Space>", "<Nop>")
keymap({ "n", "v" }, "<S-Space>", "<Space>", { remap = true })
keymap("i", "<C-Space>", "<Nop>")
keymap({ "n", "v" }, "<Space>y", [[mm"+y]])
keymap("n", "<Space>yy", [[mm0vg_"+y]])
keymap({ "n", "v" }, "<Space>Y", klib.yank_all_sys_clip)
-- keymap({ "n", "v" }, "<Space>p", [["+p]])
-- keymap({ "n", "v" }, "<Space>P", [["+P]])
keymap({ "n", "v" }, "<Space>?", "<Cmd>set hlsearch!<CR>")
keymap({ "n", "v" }, "<Space>I", "<Cmd>set ignorecase!<CR>")
keymap({ "n", "v" }, "<Space>TN", klib.toggle_line_numeration)
keymap({ "n", "v" }, "<Space>TR", klib.toggle_relative_numeration)
keymap({ "n", "v" }, "<Space>TT", klib.toggle_tab_width)
keymap({ "n", "v" }, "<Space>TW", klib.toggle_line_wrap)
keymap({ "n", "v" }, "<Space>C", klib.toggle_fixed_signcolumn)
keymap("n", "<Space>rp", [[:s/\<<C-R><C-W>\>//g<Left><Left>]])
keymap("n", "<Space>RP", [[:%s/\<<C-R><C-W>\>//g<Left><Left>]])
keymap("v", "<Space>rp", function()
  local replacement = vim.fn.input("New: ")
  if replacement ~= "" then
    vim.cmd("s/" .. ulib.get_visual() .. "/" .. replacement .. "/g")
  end
  ulib.norm([[<Esc>]])
end)
keymap("v", "<Space>RP", function()
  vim.cmd([[%s/]] .. ulib.get_visual() .. "/" .. vim.fn.input("New: ") .. "/g")
  ulib.norm([[<Esc><C-O>]])
end)
vim.keymap.set("n", "<Space>e", vim.cmd.NvimTreeFindFile)
keymap({ "n", "v" }, "<Space>BD", function()
  vim.cmd("%bd")
  ulib.norm("<C-O>")
end)

-- Splits
keymap({ "n", "v" }, "<C-W>s", "<C-W>s<C-W>j")
keymap({ "n", "v" }, "<C-W>v", "<C-W>v<C-W>l")
keymap({ "n", "v" }, "<C-W><C-S>", "<C-W>s<C-W>j")
keymap({ "n", "v" }, "<C-W><C-V>", "<C-W>v<C-W>l")
keymap({ "n", "v" }, "<C-H>", "<C-W>h")
keymap({ "n", "v" }, "<C-J>", "<C-W>j")
keymap({ "n", "v" }, "<C-K>", "<C-W>k")
keymap({ "n", "v" }, "<C-L>", "<C-W>l")
keymap({ "n", "v" }, "<C-S-H>", "3<C-W><")
keymap({ "n", "v" }, "<C-S-J>", "<C-W>-")
keymap({ "n", "v" }, "<C-S-K>", "<C-W>+")
keymap({ "n", "v" }, "<C-S-L>", "3<C-W>>")

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
keymap({ "n", "v" }, "<C-W>n", klib.rename_tab)
keymap({ "n", "v" }, "<C-W><C-N>", klib.rename_tab)
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
keymap("n", "g;", klib.prev_insert_pos)
keymap("n", "g<C-O>", klib.longjump_back)
keymap("n", "g<C-I>", klib.longjump_forward)
keymap("n", "<C-M-Left>", klib.longjump_back)
keymap("n", "<C-M-Right>", klib.longjump_forward)

-- Quickfix list
keymap({ "n", "v" }, "gq", vim.cmd.copen)
keymap({ "n", "v" }, "[q", ulib.cprev)
keymap({ "n", "v" }, "]q", ulib.cnext)

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
keymap({ "n", "v", "t" }, "<C-Q>", function()
  pcall(vim.cmd.quit)
end)
keymap({ "n", "v" }, "<C-S>", ":<C-U>write<CR>", { silent = true })
keymap("i", "<C-S>", "<C-O>:<C-U>write<CR>", { silent = true })
keymap("i", "<C-Z>", "<C-O>u")
keymap("i", "<C-S-Z>", "<C-O><C-R>")
keymap({ "n", "v" }, "<Tab>", "<C-^>")

-- Terminal mode
keymap("n", "<Space>\\", vim.cmd.terminal)
keymap("t", "<Esc>", vim.cmd.stopinsert)
keymap("t", ":", "<C-\\><C-O><:")
keymap("t", "<C-H>", "<C-\\><C-O><C-W>h")
keymap("t", "<C-J>", "<C-\\><C-O><C-W>j")
keymap("t", "<C-K>", "<C-\\><C-O><C-W>k")
keymap("t", "<C-L>", "<C-\\><C-O><C-W>l")

-- Mouse
keymap({ "n", "v" }, "<S-ScrollWheelUp>", "<ScrollWheelLeft>")
keymap({ "n", "v" }, "<S-ScrollWheelDown>", "<ScrollWheelRight>")
keymap({ "i", "n", "v" }, "<LeftMouse>", function()
  vim.opt_local.scrolloff = math.floor(vim.api.nvim_win_get_height(0) / 20)
  vim.opt_local.sidescrolloff = math.floor(vim.api.nvim_win_get_width(0) / 60)
  ulib.norm("<LeftMouse>")
end)

-- Snippets
keymap("s", "<BS>", "_<C-W>")
keymap("s", "<C-C>", "<Esc>")
