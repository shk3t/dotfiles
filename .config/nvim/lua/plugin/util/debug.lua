local dap = require("dap")
local dap_ui = require("dap.ui")
local state = require("state")

local M = {}

M.trigger_first_action = function()
  dap_ui.trigger_actions({ mode = "first" })
end

M.update_focused_thread = function()
  local session = dap.session()
  if not session then
    return false
  end

  local f_thread = state.dap.focus.thread
  f_thread.id = f_thread.id or session.stopped_thread_id
  f_thread.name = session.threads[f_thread.id].name
  return true
end

return M
