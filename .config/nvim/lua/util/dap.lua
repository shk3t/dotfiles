local cmds = require("lib.cmds")
local dap = require("dap")
local tables = require("lib.base.table")

local function breakpoint_jump(find_func)
  local row, cur_col = unpack(vim.api.nvim_win_get_cursor(0))
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  vim.cmd.copen()
  dap.list_breakpoints()
  local qflist = vim.fn.getqflist()
  vim.cmd.cclose()
  vim.api.nvim_set_current_win(win)
  qflist = vim.tbl_filter(function(v)
    return v.bufnr == buf
  end, qflist)
  if tables.is_empty(qflist) then
    return
  end
  cmds.save_jump()
  vim.api.nvim_win_set_cursor(0, { find_func(row, qflist), cur_col })
end

local M = {}

function M.breakpoint_jump_back()
  breakpoint_jump(function(cur_row, qflist)
    for i = #qflist, 1, -1 do
      if qflist[i].lnum - cur_row < 0 then
        return qflist[i].lnum
      end
    end
    return qflist[#qflist].lnum
  end)
end

function M.breakpoint_jump_forward()
  breakpoint_jump(function(cur_row, qflist)
    for i = 1, #qflist do
      if qflist[i].lnum - cur_row > 0 then
        return qflist[i].lnum
      end
    end
    return qflist[1].lnum
  end)
end

return M
