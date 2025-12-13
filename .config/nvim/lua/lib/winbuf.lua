local consts = require("consts")
local inputs = require("lib.base.input")
local state = require("state")
local strings = require("lib.base.string")
local tables = require("lib.base.table")

local M = {}

function M.do_in_win(win, action, args)
  local prev_win = vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(win)
  action(unpack(args or {}))
  vim.api.nvim_set_current_win(prev_win)
end

function M.term(command)
  -- Create buf if not exists
  if not vim.api.nvim_buf_is_valid(state.main_term.buf) then
    state.main_term.buf = vim.api.nvim_create_buf(false, true)
  end

  -- Create win if not exists
  if not vim.api.nvim_win_is_valid(state.main_term.win) then
    state.main_term.win = vim.api.nvim_open_win(state.main_term.buf, false, {
      split = "below",
      height = 16,
    })
  end

  -- Use buf as terminal if it is not
  if vim.bo[state.main_term.buf].filetype ~= "terminal" then
    M.do_in_win(state.main_term.win, vim.cmd.terminal)
    vim.cmd.sleep("50m") -- Shell initialization time
  end

  vim.fn.chansend(vim.bo[state.main_term.buf].channel, { "\x15" .. command .. "\r\n" })
  M.do_in_win(state.main_term.win, inputs.tnorm, { "G" }) -- scroll to the end
end

-- Which are automatically spawned to serve main buffers
function M.is_auxiliary_buffer(buf)
  buf = buf or 0
  local buf_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")

  return vim.list_contains(consts.AUXILIARY_BUF.FILENAMES, buf_name)
    or strings.contains(buf_name, consts.DAP.REPL_FILENAME_PATTERN)
    or vim.bo[buf].filetype == "terminal"
end

return M
