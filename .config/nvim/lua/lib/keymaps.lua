local consts = require("lib.consts")
local ulib = require("lib.utils")

local M = {}

M.toggle_line_numeration = function()
  vim.opt.number = not vim.o.number
  vim.opt.relativenumber = vim.o.number
end
M.toggle_relative_numeration = function()
  if vim.o.number then
    vim.opt.relativenumber = not vim.o.relativenumber
  end
end
M.toggle_tab_width = function()
  vim.opt.shiftwidth = vim.o.shiftwidth == 4 and 2 or 4
  vim.opt.tabstop = vim.o.shiftwidth
  vim.opt.softtabstop = vim.o.shiftwidth
end
M.toggle_line_wrap = function()
  vim.opt.wrap = not vim.o.wrap
end

M.rename_tab = function()
  local tabname = vim.fn.input("New tab name: ")
  if tabname then
    vim.cmd("TabRename " .. tabname)
  end
end

M.toggle_fixed_signcolumn = function()
  if vim.o.signcolumn:find("auto") then
    vim.opt.signcolumn = "yes"
  else
    vim.opt.signcolumn = "auto:1-2"
  end
end

M.prev_insert_pos = function()
  pcall(function()
    local next_row = unpack(vim.api.nvim_win_get_cursor(0))
    repeat
      local prev_row = next_row
      ulib.norm("g;")
      next_row = unpack(vim.api.nvim_win_get_cursor(0))
    until prev_row ~= next_row
  end)
end

M.longjump = function(key)
  pcall(function()
    local prime_buf = vim.api.nvim_get_current_buf()
    local next_row = -1
    repeat
      local prev_row = next_row
      ulib.norm(key)
      next_row = unpack(vim.api.nvim_win_get_cursor(0))
    until prime_buf ~= vim.api.nvim_get_current_buf() or prev_row == next_row
  end)
end
M.longjump_back = function()
  M.longjump("<C-O>")
end
M.longjump_forward = function()
  M.longjump("<C-I>")
end
M.longjump_back_skip_auxiliary = function()
  repeat
    M.longjump("<C-O>")
  until not ulib.is_auxiliary_buffer()
  vim.cmd.stopinsert()
end

M.yank_all_sys_clip = function()
  ulib.norm("mm")
  vim.cmd("%y y")
  vim.fn.setreg("+", vim.fn.getreg("y"):sub(1, -2))
end

M.set_default_scrolloff = function()
  vim.opt_local.scrolloff = math.floor(vim.api.nvim_win_get_height(0) / 5)
  vim.opt_local.sidescrolloff = math.floor(vim.api.nvim_win_get_width(0) / 5)
end

return M
