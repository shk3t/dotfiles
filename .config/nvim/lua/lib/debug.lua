local M = {}

local dap = require("dap")
local dap_ui = require("dap.ui")
local state = require("lib.state")

M.update_focused_thread = function()
  local session = dap.session()
  if not session then
    return false
  end

  state.dap.focus.thread.id = state.dap.focus.thread.id or session.stopped_thread_id
  return true
end

M.trigger_first_action = function()
  dap_ui.trigger_actions({ mode = "first" })
end

return M
