local consts = require("consts")
local inputs = require("lib.base.input")
local winbufs = require("lib.winbuf")

local M = {}

-- Toggling opts
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
M.toggle_fixed_signcolumn = function()
  if vim.o.signcolumn:find("auto") then
    vim.opt.signcolumn = "yes"
  else
    vim.opt.signcolumn = "auto:1-2"
  end
end
M.set_default_scrolloff = function()
  vim.wo.scrolloff = math.floor(vim.api.nvim_win_get_height(0) / 5)
  vim.wo.sidescrolloff = math.floor(vim.api.nvim_win_get_width(0) / 5)
end

-- Jumps
M.preserve_location = function(callback)
  if type(callback) == "string" then
    return function()
      M.norm("m" .. consts.PRESERVE_MARK .. callback .. "`" .. consts.PRESERVE_MARK)
      vim.cmd.delmarks(consts.PRESERVE_MARK)
    end
  end

  return function()
    M.norm("m" .. consts.PRESERVE_MARK)
    callback()
    M.norm("`" .. consts.PRESERVE_MARK)
    vim.cmd.delmarks(consts.PRESERVE_MARK)
  end
end
M.save_jump = function()
  vim.cmd("normal! m'")
end
M.prev_insert_pos = function()
  pcall(function()
    local next_row = unpack(vim.api.nvim_win_get_cursor(0))
    repeat
      local prev_row = next_row
      inputs.norm("g;")
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
      inputs.rnorm(key)
      next_row = unpack(vim.api.nvim_win_get_cursor(0))
    until prime_buf ~= vim.api.nvim_get_current_buf() or prev_row == next_row
  end)
end
M.longjump_back = function()
  M.longjump("<C-O>")
end
M.longjump_forward = function()
  M.longjump([[\\i]])
end
M.longjump_back_skip_auxiliary = function()
  repeat
    M.longjump("<C-O>")
  until not winbufs.is_auxiliary_buffer()
  vim.cmd.stopinsert()
end

-- Quickfix
M.quiet_cprev = function()
  if not pcall(vim.cmd.cprevious) then
    vim.cmd.clast()
  end
end
M.quiet_cnext = function()
  if not pcall(vim.cmd.cnext) then
    vim.cmd.cfirst()
  end
end

-- Other
M.rename_tab = function()
  local tabname = vim.fn.input("New tab name: ")
  if tabname then
    vim.cmd("TabRename " .. tabname)
  end
end

M.center_win = function()
  vim.cmd("normal! zz")
end

M.get_visual = function()
  local _, ls, cs = unpack(vim.fn.getpos("v"))
  local _, le, ce = unpack(vim.fn.getpos("."))
  if ls > le then
    ls, le = le, ls
  end
  if cs > ce then
    cs, ce = ce, cs
  end
  local visual = vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
  return visual[1] or ""
end

M.yank_all_sys_clip = function()
  inputs.norm("mm")
  vim.cmd("%y y")
  vim.fn.setreg("+", vim.fn.getreg("y"):sub(1, -2))
end

M.map_easy_closing = function()
  vim.keymap.set("n", "q", ":q<CR>", {
    buffer = true,
    silent = true,
  })
end

return M
