local consts = require("consts")
local state = require("state")

local M = {}

M.get_layout = function()
  if consts.SYSTEM.IS_KDE then
    return tonumber(vim.fn.system([[qdbus org.kde.keyboard /Layouts org.kde.KeyboardLayouts.getLayout]]))
  end
end

M.set_layout = function(idx)
  if consts.SYSTEM.IS_KDE then
    vim.fn.system([[qdbus org.kde.keyboard /Layouts org.kde.KeyboardLayouts.setLayout ]] .. tostring(idx))
  end
end

M.get_terminal_window = function()
  if consts.SYSTEM.IS_XDOTOOL_AVAILABLE then
    return tonumber(vim.fn.system([[xdotool getactivewindow]]))
  end
  return -1
end

M.focus_window = function(window_id)
  if consts.SYSTEM.IS_XDOTOOL_AVAILABLE then
    vim.fn.system("xdotool windowactivate " .. tostring(window_id))
  end
end

M.get_tmux_window = function()
  return tonumber(vim.fn.system([[tmux display-message -p "#I"]]))
end

M.focus_tmux_window = function(window_id)
  vim.fn.system("[[ $TMUX ]] && tmux select-window -t " .. tostring(window_id))
end

(function()
  state.system.terminal_window_id = M.get_terminal_window()
  state.system.tmux_window_id = M.get_tmux_window()
end)()

return M
