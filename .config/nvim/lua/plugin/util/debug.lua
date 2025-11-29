local M = {}

local consts = require("consts")
local dap = require("dap")
local dap_ui = require("dap.ui")
local files = require("lib.file")
local state = require("state")

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

M.trigger_first_action = function()
  dap_ui.trigger_actions({ mode = "first" })
end

M.python_path = (function()
  local venvdirs = { "venv", ".venv" }

  for _, venvdir in pairs(venvdirs) do
    local pybin = files.backward_file_search(venvdir .. "/bin/python")
    if pybin and vim.fn.executable(pybin) == 1 then
      return pybin
    end
  end

  return consts.DEFAULT_PYTHON_PATH
end)()

return M
