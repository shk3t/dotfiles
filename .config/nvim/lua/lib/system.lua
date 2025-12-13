local consts = require("consts")
local state = require("state")

local M = {}

function M.get_layout()
  if consts.SYSTEM.IS_KDE then
    return tonumber(vim.fn.system([[qdbus org.kde.keyboard /Layouts org.kde.KeyboardLayouts.getLayout]]))
  end
end

function M.set_layout(idx)
  if consts.SYSTEM.IS_KDE then
    vim.fn.system([[qdbus org.kde.keyboard /Layouts org.kde.KeyboardLayouts.setLayout ]] .. tostring(idx))
  end
end

function M.get_terminal_window()
  if consts.SYSTEM.IS_XDOTOOL_AVAILABLE then
    return tonumber(vim.fn.system([[xdotool getactivewindow]]))
  end
  return -1
end

function M.get_tmux_window()
  return tonumber(vim.fn.system([[tmux display-message -p "#I"]]))
end

function M.focus_window(window_id)
  if consts.SYSTEM.IS_XDOTOOL_AVAILABLE then
    vim.fn.system("xdotool windowactivate " .. tostring(window_id))
  end
end

function M.focus_tmux_window(window_id)
  vim.fn.system("[[ $TMUX ]] && tmux select-window -t " .. tostring(window_id))
end

local function init()
  state.system.terminal_window_id = M.get_terminal_window()
  state.system.tmux_window_id = M.get_tmux_window()
end
init()

return M
