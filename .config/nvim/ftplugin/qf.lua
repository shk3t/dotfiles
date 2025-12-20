local keymap = vim.keymap.set
local inputs = require("lib.base.input")
local state = require("state")

keymap("n", "<CR>", "<CR>", { buffer = true }) -- Go to position

keymap("n", "dd", function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local qflist = vim.fn.getqflist()
  state.qf.prev_list = vim.deepcopy(qflist)
  state.qf.prev_pos = { row, col }
  table.remove(qflist, row)
  vim.fn.setqflist(qflist, "r")
  if not pcall(vim.api.nvim_win_set_cursor, 0, { row, col }) then
    vim.api.nvim_win_set_cursor(0, {
      row - 1,
      col,
    })
  end
end, { buffer = true })

keymap("x", "d", function()
  inputs.norm("<Esc>")
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local sl = vim.fn.line("'<")
  local el = vim.fn.line("'>")
  local qflist = vim.fn.getqflist()
  state.qf.prev_list = vim.deepcopy(qflist)
  state.qf.prev_pos = { row, col }
  for line = sl, el do
    table.remove(qflist, sl)
  end
  vim.fn.setqflist(qflist, "r")
  local actual_row = row - (el - sl) + 1
  if not pcall(vim.api.nvim_win_set_cursor, 0, { actual_row, col }) then
    pcall(vim.api.nvim_win_set_cursor, 0, { sl - 1, col })
  end
end, { buffer = true })

keymap("n", "u", function()
  if not state.qf.prev_list then
    return
  end
  vim.fn.setqflist(state.qf.prev_list, "r")
  pcall(vim.api.nvim_win_set_cursor, 0, state.qf.prev_pos)
  state.qf.prev_list = nil
end, { buffer = true })

keymap("n", "<Space>rs", [[:cdo s/\<<C-R><C-W>\>//g<Left><Left>]], { buffer = true })
