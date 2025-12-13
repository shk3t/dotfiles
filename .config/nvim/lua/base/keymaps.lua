local keymap = vim.keymap.set
local cmds = require("lib.cmds")
local inputs = require("lib.base.input")

-- Distinguish keypresses
keymap({ "n", "x" }, "<Space>", "<Nop>")
keymap({ "n", "x" }, "<S-Space>", "<Space>", { remap = true })
keymap("n", "<C-I>", "<C-I>")
keymap("n", [[\\i]], "<C-I>")
keymap("n", "<C-M>", "<C-M>")

-- Old school
keymap({ "n", "x" }, "<C-S>", ":<C-U>write<CR>", { silent = true })
keymap("i", "<C-S>", "<C-O>:<C-U>write<CR>", { silent = true })
keymap("i", "<C-Z>", "<C-O>u")
keymap("i", "<C-S-Z>", "<C-O><C-R>")
keymap("i", "<C-Del>", "<C-O>de")
keymap("n", "<M-Left>", "<C-O>")
keymap("n", "<M-Right>", "<C-I>")

-- Default behaviour
keymap({ "i", "n", "x" }, "<C-C>", "<Esc>")
keymap({ "n", "x" }, "<BS>", "s")
keymap("x", "$", "g_")
keymap("n", "J", function()
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd("join " .. vim.v.count + 1)
  vim.api.nvim_win_set_cursor(0, pos)
end)

-- Options toggle
keymap("n", "<Space>TI", "<Cmd>set ignorecase!<CR>")
keymap("n", "<Space>TN", cmds.toggle_line_numeration)
keymap("n", "<Space>TR", cmds.toggle_relative_numeration)
keymap("n", "<Space>TT", cmds.toggle_tab_width)
keymap("n", "<Space>TW", cmds.toggle_line_wrap)
keymap("n", "<Space>TS", cmds.toggle_fixed_signcolumn)

-- View
keymap({ "n", "x" }, "ZL", "zL")
keymap({ "n", "x" }, "ZH", "zH")

-- Search
keymap({ "n", "x" }, "n", "'Nn'[v:searchforward]", { expr = true })
keymap({ "n", "x" }, "N", "'nN'[v:searchforward]", { expr = true })
keymap({ "n", "x" }, "g/", [[/\<\><Left><Left>]])
keymap({ "n", "x" }, "g?", [[?\<\><Left><Left>]])
keymap("n", "<CR>", function()
  vim.fn.setreg("/", [[\<]] .. vim.fn.expand("<cword>") .. [[\>]])
end)
keymap("n", "g<CR>", function()
  vim.fn.setreg("/", vim.fn.expand("<cword>"))
end)
keymap("x", "<CR>", function()
  vim.fn.setreg("/", cmds.get_visual())
  inputs.norm("<Esc>")
end)

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
keymap("n", "g;", cmds.prev_insert_pos)
keymap("n", "g<C-O>", cmds.longjump_back)
keymap("n", "g<C-I>", cmds.longjump_forward)
keymap("n", "<C-M-Left>", cmds.longjump_back)
keymap("n", "<C-M-Right>", cmds.longjump_forward)
keymap("n", "<Tab>", "<C-^>")

-- Copy-yank-paste
keymap({ "n", "x" }, "y", cmds.preserve_pos_pre("y"), { expr = true })
keymap({ "n", "x" }, "<Space>y", cmds.preserve_pos_pre([["+y]]), { expr = true })
keymap({ "n", "x" }, "<C-S-C>", cmds.preserve_pos_pre([["+y]]), { expr = true })
keymap("n", "<Space>yy", cmds.preserve_pos_pre([[0vg_"+y]]), { expr = true })
keymap("n", "<Space>Y", cmds.yank_all_sys_clip)
keymap("x", "P", [["0p]])
keymap("i", "<C-V>", function()
  local joined_clipboard = vim.fn.getreg('"'):gsub("[\n\r]", " "):gsub("%s+", " ")
  vim.api.nvim_put({ joined_clipboard }, "", false, true)
end)
keymap("c", "<C-V>", '<C-R>"')

-- Substitute
keymap("n", "<Space>rp", [[:s/\<<C-R><C-W>\>//g<Left><Left>]])
keymap("n", "<Space>RP", [[:%s/\<<C-R><C-W>\>//g<Left><Left>]])
keymap("x", "<Space>rp", function()
  local replacement = vim.fn.input("New: ")
  if replacement ~= "" then
    vim.cmd("s/" .. cmds.get_visual() .. "/" .. replacement .. "/g")
  end
  inputs.norm([[<Esc>]])
end)
keymap("x", "<Space>RP", function()
  vim.cmd([[%s/]] .. cmds.get_visual() .. "/" .. vim.fn.input("New: ") .. "/g")
  inputs.norm([[<Esc><C-O>]])
end)

-- Splits
keymap("n", "<C-W>s", "<C-W>s<C-W>j")
keymap("n", "<C-W>v", "<C-W>v<C-W>l")
keymap("n", "<C-W><C-S>", "<C-W>s<C-W>j")
keymap("n", "<C-W><C-V>", "<C-W>v<C-W>l")
keymap("n", "<C-H>", "<C-W>h")
keymap("n", "<C-J>", "<C-W>j")
keymap("n", "<C-K>", "<C-W>k")
keymap("n", "<C-L>", "<C-W>l")
keymap({ "n", "x" }, "<C-S-H>", "3<C-W><")
keymap({ "n", "x" }, "<C-S-J>", "<C-W>-")
keymap({ "n", "x" }, "<C-S-K>", "<C-W>+")
keymap({ "n", "x" }, "<C-S-L>", "3<C-W>>")
keymap({ "n", "x", "t" }, "<C-Q>", function()
  pcall(vim.cmd.quit)
end)

-- Tabs
keymap("n", "<C-W>c", "<C-W><Esc>")
keymap("n", "<C-W><C-C>", "<C-W><Esc>")
keymap("n", "<C-W>t", "<C-W>v<C-W>T")
keymap("n", "<C-W><C-T>", "<C-W>v<C-W>T")
keymap("n", "<C-W>,", vim.cmd.tabprevious)
keymap("n", "<C-W>.", vim.cmd.tabnext)
keymap("n", "<C-W><C-,>", vim.cmd.tabprevious)
keymap("n", "<C-W><C-.>", vim.cmd.tabnext)
for i = 1, 9 do
  keymap("n", "<C-W>" .. i, "<Cmd>" .. i .. "tabnext<CR>")
  keymap("n", "<Space>" .. i, "<Cmd>" .. i .. "tabnext<CR>")
end
keymap("n", "<C-W><", "<Cmd>-tabmove<CR>")
keymap("n", "<C-W>>", "<Cmd>+tabmove<CR>")
keymap("n", "<C-W>Q", vim.cmd.tabclose)
keymap("n", "<C-W>n", cmds.rename_tab)
keymap("n", "<C-W><C-N>", cmds.rename_tab)
keymap("n", "<Space><Tab>", "g<Tab>")
keymap("n", "<C-W>p", "g<Tab>")

-- Quickfix list
keymap("n", "gq", vim.cmd.copen)
keymap("n", "[q", cmds.quiet_cprev)
keymap("n", "]q", cmds.quiet_cnext)

-- Marks
local buffer_marks = "abcdefghijklmnopqrstuvwxyz"
for i = 1, #buffer_marks do
  local mark = buffer_marks:sub(i, i)
  keymap({ "n", "x" }, "m" .. mark, "m" .. mark:upper())
  keymap({ "n", "x" }, "'" .. mark, "'" .. mark:upper())
end
keymap("n", "dM", function()
  vim.cmd.delmarks("a-zA-Z")
end)

-- Terminal mode
keymap("n", "<Space>\\", vim.cmd.terminal)
keymap("t", "<Esc>", vim.cmd.stopinsert)
keymap("t", ":", "<C-\\><C-O><:")
keymap("t", "<C-H>", "<C-\\><C-O><C-W>h")
keymap("t", "<C-J>", "<C-\\><C-O><C-W>j")
keymap("t", "<C-K>", "<C-\\><C-O><C-W>k")
keymap("t", "<C-L>", "<C-\\><C-O><C-W>l")

-- Mouse
keymap({ "n", "x" }, "<S-ScrollWheelUp>", "<ScrollWheelLeft>")
keymap({ "n", "x" }, "<S-ScrollWheelDown>", "<ScrollWheelRight>")
keymap({ "n", "i", "x" }, "<LeftMouse>", function()
  vim.wo.scrolloff = math.floor(vim.api.nvim_win_get_height(0) / 20)
  vim.wo.sidescrolloff = math.floor(vim.api.nvim_win_get_width(0) / 60)
  inputs.norm("<LeftMouse>")
end)

-- Snippets
keymap("s", "<BS>", "_<C-W>")
keymap("s", "<C-C>", "<Esc>")
