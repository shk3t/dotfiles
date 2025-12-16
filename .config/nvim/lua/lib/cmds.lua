local consts = require("consts")
local inputs = require("lib.base.input")
local state = require("state")
local winbufs = require("lib.winbuf")

local M = {}

-- Toggling opts
function M.toggle_tab_width()
  vim.o.shiftwidth = vim.o.shiftwidth == 4 and 2 or 4
  vim.o.tabstop = vim.o.shiftwidth
  vim.o.softtabstop = vim.o.shiftwidth
end
function M.toggle_line_wrap()
  vim.o.wrap = not vim.o.wrap
end
function M.toggle_line_numeration()
  vim.o.number = not vim.o.number
  vim.o.relativenumber = vim.o.number
end
function M.toggle_relative_numeration()
  if vim.o.number then
    vim.o.relativenumber = not vim.o.relativenumber
  end
end
function M.toggle_fixed_signcolumn()
  if vim.o.signcolumn:find("auto") then
    vim.o.signcolumn = "yes"
  else
    vim.o.signcolumn = "auto:1-2"
  end
end
function M.set_default_scrolloff()
  vim.wo.scrolloff = math.floor(vim.api.nvim_win_get_height(0) / 5)
  vim.wo.sidescrolloff = math.floor(vim.api.nvim_win_get_width(0) / 5)
end

-- Jumps
---@param callback string|function
function M.preserve_pos(callback)
  if type(callback) == "string" then
    return function()
      state.preserved_position = vim.api.nvim_win_get_cursor(0)
      inputs.norm(callback)
      vim.api.nvim_win_set_cursor(0, state.preserved_position)
      state.preserved_position = nil
    end
  end

  return function()
    state.preserved_position = vim.api.nvim_win_get_cursor(0)
    callback()
    vim.api.nvim_win_set_cursor(0, state.preserved_position)
    state.preserved_position = nil
  end
end
---@param expr string
--- When post hook restores position (e.g. "TextYankPost")
function M.preserve_pos_pre(expr)
  return function()
    state.preserved_position = vim.api.nvim_win_get_cursor(0)
    return expr
  end
end
function M.save_jump()
  vim.cmd("normal! m'")
end
function M.prev_insert_pos()
  pcall(function()
    local next_row = unpack(vim.api.nvim_win_get_cursor(0))
    repeat
      local prev_row = next_row
      inputs.norm("g;")
      next_row = unpack(vim.api.nvim_win_get_cursor(0))
    until prev_row ~= next_row
  end)
end
function M.longjump(key)
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
function M.longjump_back()
  M.longjump("<C-O>")
end
function M.longjump_forward()
  M.longjump([[\\i]])
end
function M.longjump_back_skip_auxiliary()
  repeat
    M.longjump("<C-O>")
  until not winbufs.is_auxiliary_buffer()
  vim.cmd.stopinsert()
end

-- Quickfix
function M.quiet_cprev()
  if not pcall(vim.cmd.cprevious) then
    vim.cmd.clast()
  end
end
function M.quiet_cnext()
  if not pcall(vim.cmd.cnext) then
    vim.cmd.cfirst()
  end
end

-- Other
function M.center_win()
  vim.cmd("normal! zz")
end

function M.get_visual()
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

function M.yank_all_sys_clip()
  vim.cmd("%y y")
  vim.fn.setreg("+", vim.fn.getreg("y"):sub(1, -2))
end

function M.map_easy_closing()
  vim.keymap.set("n", "q", ":q<CR>", {
    buffer = true,
    silent = true,
  })
end

return M
