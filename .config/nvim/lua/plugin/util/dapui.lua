local consts = require("consts")
local dap = require("dap")
local dap_ui = require("dap.ui")
local state = require("state")
local strings = require("lib.base.string")
local tables = require("lib.base.table")
local widgets = require("dap.ui.widgets")

local function update_focused_thread()
  local session = dap.session()
  if not session then
    return false
  end

  local f_thread = state.dap.focus.thread
  f_thread.id = f_thread.id or session.stopped_thread_id
  f_thread.name = session.threads[f_thread.id].name
  return true
end

local M = {}

function M.trigger_first_action()
  dap_ui.trigger_actions({ mode = "first" })
end

function M.switch_thread_focus(step)
  if not update_focused_thread() or step == 0 then
    return
  end
  local threads = tables.compact(dap.session().threads)
  local f_thread = state.dap.focus.thread

  local start
  for i, v in pairs(threads) do
    if v.id == f_thread.id then
      start = i + 1
      print("i:", i)
    end
  end
  local finish = start + #threads - 2
  if step < 0 then
    start, finish = finish, start
  end

  for i = start, finish, step do
    local thread = threads[(i - 1) % #threads + 1]
    if not strings.contains_any(thread.name, consts.DAP.RUNTIME_THREADS) then
      f_thread.id = thread.id
      f_thread.name = thread.name
      break
    end
  end

  widgets.centered_float(widgets.threads)
  vim.fn.search("\\V" .. f_thread.name)
  M.trigger_first_action()
  vim.cmd.sleep("1m")
  vim.fn.search([[^\(.*\<\(]] .. table.concat(consts.DAP.RUNTIME_THREADS, [[\|]]) .. [[\)\>\)\@!.*$]])
  M.trigger_first_action()
end

return M
