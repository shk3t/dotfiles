local norm = require("lib.main").norm
-- vim.g.prev_qflist = nil
-- vim.g.prev_qfpos = nil

vim.keymap.set("n", "dd", function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local qflist = vim.fn.getqflist()
  vim.g.prev_qflist = qflist
  vim.g.prev_qfpos = {row, col}
  table.remove(qflist, row)
  vim.fn.setqflist(qflist, "r")
  if not pcall(function() vim.api.nvim_win_set_cursor(0, {row, col}) end) then
    vim.api.nvim_win_set_cursor(0, {row - 1, col})
  end
end, {buffer = true})

vim.keymap.set("x", "d", function()
  norm("<Esc>")
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local qflist = vim.fn.getqflist()
  vim.g.prev_qflist = qflist
  vim.g.prev_qfpos = {row, col}
  for line = start_line, end_line do table.remove(qflist, start_line) end
  vim.fn.setqflist(qflist, "r")
  local actual_row = row - (end_line - start_line) + 1
  if not pcall(function() vim.api.nvim_win_set_cursor(0, {actual_row, col}) end) then
    pcall(function() vim.api.nvim_win_set_cursor(0, {start_line - 1, col}) end)
  end
end, {buffer = true})

vim.keymap.set("n", "u", function()
  if not vim.g.prev_qflist then return end
  vim.fn.setqflist(vim.g.prev_qflist, "r")
  pcall(function() vim.api.nvim_win_set_cursor(0, vim.g.prev_qfpos) end)
  vim.g.prev_qflist = nil
end, {buffer = true})
