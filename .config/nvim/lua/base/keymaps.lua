local keymap = vim.keymap.set
local cmds = require("lib.cmds")
local inputs = require("lib.base.input")

-- Distinguish keypresses
keymap({ "n", "x" }, "<Space>", "<NOP>")
keymap({ "n", "x" }, "<S-Space>", "<Space>", { remap = true })
keymap("n", "<C-W>c", "<NOP>")
keymap("n", "<C-W><C-C>", "<NOP>")
keymap("n", "<C-I>", "<C-I>")
keymap("n", [[\\i]], "<C-I>")
keymap("n", "<C-M>", "<C-M>")

-- Old school
keymap("n", "<C-S>", vim.cmd.write)
keymap("i", "<C-Z>", "<C-O>u")
keymap("i", "<C-S-Z>", "<C-O><C-R>")
keymap("i", "<C-Del>", "<C-O>de")
keymap("n", "<M-Left>", "<C-O>")
keymap("n", "<M-Right>", "<C-I>")

-- Default behaviour
keymap({ "i", "n", "x", "s" }, "<C-C>", "<Esc>")
keymap({ "n", "x" }, "<BS>", "s")
keymap("x", "$", "g_")
keymap("n", "J", function()
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd("join " .. vim.v.count + 1)
  vim.api.nvim_win_set_cursor(0, pos)
end)

-- Options toggle
keymap("n", "<Space>TT", cmds.toggle_tab_width)
keymap("n", "<Space>TW", cmds.toggle_line_wrap)
keymap("n", "<Space>TI", "<Cmd>set ignorecase!<CR>")
keymap("n", "<Space>TN", cmds.toggle_line_numeration)
keymap("n", "<Space>TR", cmds.toggle_relative_numeration)
keymap("n", "<Space>TS", cmds.toggle_fixed_signcolumn)

-- View
keymap({ "n", "x" }, "ZL", "zL")
keymap({ "n", "x" }, "ZH", "zH")

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
keymap("n", "<Space>rs", [[:s/\<<C-R><C-W>\>//g<Left><Left>]])
keymap("n", "<Space>RS", [[:%s/\<<C-R><C-W>\>//g<Left><Left>]])
keymap("x", "<Space>rs", function()
  local replacement = vim.fn.input("New: ")
  if replacement ~= "" then
    vim.cmd("s/" .. cmds.get_visual() .. "/" .. replacement .. "/g")
  end
  inputs.norm("<Esc>")
end)
keymap("x", "<Space>RS", function()
  local replacement = vim.fn.input("New: ")
  if replacement ~= "" then
    vim.cmd([[%s/]] .. cmds.get_visual() .. "/" .. replacement .. "/g")
  end
  inputs.norm("<Esc>")
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
keymap("n", "<C-W>,", vim.cmd.tabprevious)
keymap("n", "<C-W>.", vim.cmd.tabnext)
keymap("n", "<C-W><C-,>", vim.cmd.tabprevious)
keymap("n", "<C-W><C-.>", vim.cmd.tabnext)
keymap("n", "<C-W><", "<Cmd>-tabmove<CR>")
keymap("n", "<C-W>>", "<Cmd>+tabmove<CR>")
keymap("n", "<Space><Tab>", "g<Tab>")
for i = 1, 9 do
  keymap("n", "<Space>" .. i, "<Cmd>" .. i .. "tabnext<CR>")
end
keymap("n", "<C-W>t", "<C-W>v<C-W>T")
keymap("n", "<C-W><C-T>", "<C-W>v<C-W>T")
keymap("n", "<C-W>Q", vim.cmd.tabclose)

-- Quickfix list
keymap("n", "gq", vim.cmd.copen)
keymap("n", "[q", cmds.quiet_cprev)
keymap("n", "]q", cmds.quiet_cnext)

-- Command-line mode
keymap("c", "<Esc>", "<C-F>")

-- Terminal mode
keymap("n", "<Space>\\", vim.cmd.terminal)
keymap("t", "<Esc>", "<C-\\><C-N>")
keymap("t", ":", "<C-\\><C-O><:")
keymap("t", "<C-K>", "<C-\\><C-N><C-W>k")

-- Mouse
keymap({ "n", "x" }, "<S-ScrollWheelUp>", "<ScrollWheelLeft>")
keymap({ "n", "x" }, "<S-ScrollWheelDown>", "<ScrollWheelRight>")
keymap({ "n", "i", "x" }, "<LeftMouse>", function()
  cmds.set_minimal_scrolloff()
  inputs.norm("<LeftMouse>")
end)

-- Snippets
keymap("s", "<BS>", "_<C-W>")

-- Tweaks
keymap("n", "gt", cmds.toggle_todo)
keymap("n", "gT", cmds.toggle_todo_append)
